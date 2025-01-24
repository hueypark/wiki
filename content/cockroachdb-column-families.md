---
layout: post
title: "카크로치디비의 컬럼 패밀리"
date: "2020-05-26"
tags: ["cockroachdb"]
---

카크로치디비의 컬럼 패밀리에 대해 소개합니다.
실제 스토리지 레이어에 어떻게 데이터가 기록되는지에 관심이 있거나,
더 효율적인 테이블 설계를 하고 싶은 분에게 도움이 되는 내용입니다.

<!--more-->

### 컬럼 패밀리

컬럼 패밀리는 키밸류 저장소에 단일 키로 저장되는 컬럼 그룹입니다. 다시 말하면 같은 컬럼 패밀리에
있는 데이터는 저장될 때 키밸류 저장소의 한 키에 같이 저장됩니다.

기본적으로 테이블의 모든 컬럼은 하나의 컬럼 패밀리로 저장되며, 이러한 동작은 대부분의 경우에
효율적입니다. 하지만 자주 변경되는 컬럼과 거의 변경되지 않는 컬럼이 함께 있다면, 거의 업데이트되지
않는 컬럼을 불필요하게 다시 쓰는 문제가 있습니다. 특히 거의 업데이트되지 않는 컬럼이 매우 크다면
다른 컬럼 패밀리로 구분하는 것이 무척 효과적입니다.

### 조금 더 알아볼까요?

먼저 테스트용 데이터베이스와 테이블을 생성하겠습니다.

```sql
CREATE DATABASE test_db;

USE test_db;

CREATE TABLE t1 (a INT PRIMARY KEY, b INT, c INT);

CREATE TABLE t2 (a INT PRIMARY KEY, b INT, c INT, FAMILY(a), FAMILY(b), FAMILY(c));
```

아래처럼 t1은 하나의 컬럼 패밀리를 가지고, t2는 3개의 컬럼 패밀리를 가집니다. 이는 `SHOW CREATE t*`의
결과 중 `FAMILY` 항목을 통해 확일할 수 있습니다.

```sql
SHOW CREATE t1;

  table_name |               create_statement
-------------+------------------------------------------------
  t1         | CREATE TABLE t1 (
             |     a INT8 NOT NULL,
             |     b INT8 NULL,
             |     c INT8 NULL,
             |     CONSTRAINT "primary" PRIMARY KEY (a ASC),
             |     FAMILY "primary" (a, b, c)
             | )

SHOW CREATE t2;

  table_name |               create_statement
-------------+------------------------------------------------
  t2         | CREATE TABLE t2 (
             |     a INT8 NOT NULL,
             |     b INT8 NULL,
             |     c INT8 NULL,
             |     CONSTRAINT "primary" PRIMARY KEY (a ASC),
             |     FAMILY fam_0_a (a),
             |     FAMILY fam_1_b (b),
             |     FAMILY fam_2_c (c)
             | )
```

더 진행하기 전에 카크로치디비의 멋진 디버깅 기능을 소개합니다. `\set auto_trace=on,kv` 명령어를
사용하면 스토리지 레이어의 키밸류 저장소에 어떤 데이터가 저장되는지 알 수 있습니다.

```sql
\set auto_trace=on,kv
```

이어서 데이터를 추가해 봅시다.

```sql
INSERT INTO t1 VALUES(1, 2, 3);
INSERT 1

Time: 1.023062ms

             timestamp             |       age       |                      message                       |                            tag                             | location |    operation     | span
-----------------------------------+-----------------+----------------------------------------------------+------------------------------------------------------------+----------+------------------+-------
  2020-05-26 12:56:28.282616+00:00 | 00:00:00.000366 | CPut /Table/60/1/1/0 -> /TUPLE/2:2:Int/2/1:3:Int/3 | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 12:56:28.282663+00:00 | 00:00:00.000413 | querying next range at /Table/60/1/1/0             | [n1,client=127.0.0.1:59970,hostssl,user=root,txn=95d43440] |          | dist sender send |    8
  2020-05-26 12:56:28.282699+00:00 | 00:00:00.000449 | r63: sending batch 1 CPut, 1 EndTxn to (n1,s1):1   | [n1,client=127.0.0.1:59970,hostssl,user=root,txn=95d43440] |          | dist sender send |    8
  2020-05-26 12:56:28.283225+00:00 | 00:00:00.000975 | fast path completed                                | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 12:56:28.283251+00:00 | 00:00:00.001001 | rows affected: 1                                   | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | exec stmt        |    4
(5 rows)

Time: 1.663529ms
```

내용이 많지만 우리가 집중해야 할 부분은 아래 부분입니다. 컬럼 패밀리가 하나인 경우에 로우를 추가했을
때에는 하나의 키에 모든 컬럼의 내용이 기록됩니다.

(아래 결과는 아이디 60인 테이블의 1번 키의 각 컬럼에 2와 3이 기록되었음을 의미합니다.)

```sql
CPut /Table/60/1/1/0 -> /TUPLE/2:2:Int/2/1:3:Int/3
```

이어서 여러 컬럼 패밀리를 가진 테이블에 데이터를 추가해봅시다.


```sql
INSERT INTO t2 VALUES(1, 2, 3);
INSERT 1

Time: 2.42107ms

             timestamp             |       age       |                     message                      |                            tag                             | location |    operation     | span
-----------------------------------+-----------------+--------------------------------------------------+------------------------------------------------------------+----------+------------------+-------
  2020-05-26 13:02:22.249186+00:00 | 00:00:00.001849 | CPut /Table/61/1/1/0 -> /TUPLE/                  | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 13:02:22.249198+00:00 | 00:00:00.00186  | CPut /Table/61/1/1/1/1 -> /INT/2                 | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 13:02:22.249204+00:00 | 00:00:00.001866 | CPut /Table/61/1/1/2/1 -> /INT/3                 | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 13:02:22.249231+00:00 | 00:00:00.001893 | querying next range at /Table/61/1/1/0           | [n1,client=127.0.0.1:59970,hostssl,user=root,txn=4b8bd340] |          | dist sender send |    8
  2020-05-26 13:02:22.249253+00:00 | 00:00:00.001915 | r64: sending batch 3 CPut, 1 EndTxn to (n1,s1):1 | [n1,client=127.0.0.1:59970,hostssl,user=root,txn=4b8bd340] |          | dist sender send |    8
  2020-05-26 13:02:22.249673+00:00 | 00:00:00.002336 | fast path completed                              | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | flow             |    6
  2020-05-26 13:02:22.24971+00:00  | 00:00:00.002372 | rows affected: 1                                 | [n1,client=127.0.0.1:59970,hostssl,user=root]              |          | exec stmt        |    4
(7 rows)

Time: 2.040017ms
```

이번에는 아래 내용을 확인해 주십시오. 이전과는 달리 3개의 키에 나누어져 각 컬럼의 값이 기록되었습니다.

```sql
CPut /Table/61/1/1/0 -> /TUPLE/
CPut /Table/61/1/1/1/1 -> /INT/2
CPut /Table/61/1/1/2/1 -> /INT/3
```

이어서 업데이트도 해 볼까요? 각각의 결과는 아래와 같습니다.
(이번에는 결과의 중요한 부분만 간추렸습니다.)

```sql
UPDATE t1 SET C = 4 WHERE a = 1;

Put /Table/60/1/1/0 -> /TUPLE/2:2:Int/2/1:3:Int/4

UPDATE t2 SET C = 4 WHERE a = 1;

Put /Table/61/1/1/2/1 -> /INT/4
```

차이점이 보이시나요? `t1`은 로우가 가진 모든 컬럼의 데이터가 업데이트되었고, `t2`는
변경된 컬럼의 데이터만 업데이트 되었습니다.

### 왜 이것이 중요한가요?

카크로치디비는 테이블을 생성할 때 기본적으로 모는 컬럼을 하나의 컬럼 패밀리로 묶습니다. 대부분의
경우 이는 효과적이지만 만약 여러분의 데이터가 일부 컬럼만을 자주 변경시키거나, 거의 변경되지 않는
매우 큰 컬럼이 있다면 컬럼 패밀리를 나누는 것은 성능향상에 큰 도움이 될 것입니다!

### 더 알아보고 싶다면

더 알아보고 싶다면 [공식문서](https://www.cockroachlabs.com/docs/stable/column-families.html)나
[조단의 영상강의](https://youtu.be/BqkG-1mKAXw)를 확인해보십시오.

### 감사합니다.

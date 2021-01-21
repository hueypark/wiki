---
title: "MongoDB 스터디 2주차(MongoDB 설치하기)"
date: "2021-01-17"
tags: ["MongoDB"]
---

## Replica Set

Replica set 은 같은 데이터를 가진 mongod 프로세스 그룹입니다. 이를 통해 MongoDB는 데이터 중복과 고가용성을 제공합니다. 그렇기 때문에 일부 서버에 장애가 발생하더라고 전체 시스템은 정상적으로 운영될 수 있습니다.

특정한 경우 복제를 통해 읽기 수용량을 증가시킬 수 있습니다. 또 서로 다른 데이터센터에 복사본을 유지하여 가용성을 증가시킬수 있도 장애복구, 분석, 백업 목적으로 추가 복사본을 만들 수도 있습니다.

### Replication

Replica set 은 데이터를 가진 여러 노드로 이루어지며(데이터가 없는 아비터가 추가될 수도 있음), 이 중 하나만이 primary 노드가 됩니다.

Primary 노드는 모든 쓰기 명령을 처리합니다.

{{<mermaid>}}
graph TD
	Driver  -->|쓰기| Primary
	Primary -->|복제| S1[Secondary]
	Primary -->|복제| S2[Secondary]
{{</mermaid>}}

### Oplog

데이터 변경을 저장하는 로그입니다. Binlog 가 아니기 때문에 OS나, 물리장비의 영향을 받지 않습니다. 또 그렇기 때문에 replica set 의 롤링 업그레이드가 가능합니다.

### Automatic Failover

Primary 가 설정 된 `electionTimeoutMillis` 값(기본 10초) 이상 통신되지 않으며, 새로운 Primary 를 선출을 시도합니다. 클러스터는 새로운 primary 를 선출하고 정상 동작을 재개합니다.

선출 기간 동안에는 쓰기 명령은 동작하지 않습니다. 하지만 읽기 명령은 계속 진행될 수 있습니다.

### Write concern

클라이언트에 응답을 주기 전 쓰기 고려사항입니다.

0: 으로 설정하면 데이터를 쓰기 전에 응답을 합니다. 장애 발생 시 아무것도 보장하지 않습니다.

1: 기본값으로 primary 에 데이터가 쓰여지면 응답을 합니다. 만약 secondary 에 replication 이 되기 전에 primary 장애가 된다면 데이터가 롤백될 수 있습니다.

2~: 설정된 숫자의 노드에 데이터가 쓰이면 응답을 합니다.

"majority": [과반](https://docs.mongodb.com/manual/reference/write-concern/index.html#calculating-majority-count) 이상의 노드에 데이터가 쓰이면 응답을 합니다.

### Read concern(https://docs.mongodb.com/manual/reference/read-concern/)

클라이언트에 응답을 주기 전 읽기 고려사항입니다.

["local"](https://docs.mongodb.com/manual/reference/read-concern-local/#readconcern.%22local%22), ["available"](https://docs.mongodb.com/manual/reference/read-concern-available/#readconcern.%22available%22), ["majority"](https://docs.mongodb.com/manual/reference/read-concern-majority/#readconcern.%22majority%22), ["linearizable"](https://docs.mongodb.com/manual/reference/read-concern-linearizable/#readconcern.%22linearizable%22), ["snapshot"](https://docs.mongodb.com/manual/reference/read-concern-snapshot/#readconcern.%22snapshot%22) 이 있습니다.

### Read Preferences(드라이버 설정)(https://docs.mongodb.com/manual/core/read-preference/index.html)

MongoDB 클라이언트가 읽기 요청을 replica set 의 어떤 노드로 보낼지에 대한 설정입니다.

"primary": 기본 값. 모든 읽기 요청은 primary 에게 보내집니다.

"primaryPreferred": 대부분의 상황에서 읽기가 primary 에게 보내지지만, 불가능하면 secondary 를 사용합니다.

"secondary": 모든 요청이 secondary 에게 보내집니다.

"secondaryPreferred": 대부분의 상황에서 읽기가 secondary 에게 보내지지만, 불가능하면 primary를 사용합니다.

"nearest": 응답시간을 기준으로 임의의 노드에게서 읽기를 수행합니다.

### Replica Set Arbiter

특정 상황에서는(세 번 째 노드를 배치하는 대신 비용을 줄이고 싶다거나) arbiter 를 replica set 에 추가할 수 있씁니다. Arbiter 는 데이터를 가지고 있지 않으며 failover 상황에서 투표만 하며 primary 가 될 수 없습니다.

중요!: primary 나 seconday 멤버가 있는 시스템에 arbiter 를 호스팅하지 마십시오.

### 최대 노드 수

최대 50개의 노드 설정이 가능하며, Primary 선출을 위한 투표가 가능한 노드는 최대 7개입니다.

---

## mongod 파일 구조

- /data/db
	- WiredTiger: 스토리지 엔진 관련 파일
	- WiredTiger.lock: 다른 몽고디비가 동시에 같은 디렉토리를 사용하지 못하게 막는 파일(갑작스런 장비 재시작시 삭제해 줘야 할 수도 있음)
	- WiredTiger.turtle: 스토리지 엔진 관련 파일
	- WiredTiger.wt: 스토리지 엔진 관련 파일
	- WiredTigerLAS.wt: 스토리지 엔진 관련 파일
	- collection*.wt: 컬렉션 데이터
	- index*.wt: 인덱스 데이터
	- diagnostic.data/: MongoDB 에서 기술지원시 사용하는 진단용 데이터
	- journal/: WiredTiger journal, WAL 로그, 장애 발생 시 이 로그를 이용해 checkpoint 이후 변경사항을 복구
	- mongod.lock: WiredTiger.lock 비슷하게 동시에 두 몽고디비가 같은 디렉토리를 저장소로 사용하지 못하게 막는 파일
	- sizeStorer.wt: 스토리지 엔진 관련 파일
	- storage.bson: 스토리지 엔진 관련 파일

- /tmp/mongodb-*.sock: 소켓 커넥션을 만들기 위한 파일(갑작스런 장비 재시작시 삭제해 줘야 할 수도 있음)

---

## WiredTiger 스토리지 엔진

### Document Level Concurrency

여러 클라이언트가 동시에 여러 도큐먼트를 변경할 수 있습니다.

대부분의 읽기와 쓰기에 낙관적인 잠금을 사용하며, 두 명령이 충돌하는 것을 발견하면 작업을 재시도하게 합니다.

### Snapshot 과 Checkpoint

MultiVersion Concurrency Control(MVCC) 를 사용합니다. 명령 실행 이전에 snapshot 을 남기고, 이 snapshot 은 메모리 내에서 일관된 보기를 제공합니다.

디스크에 기록할 때 snapshot 에 있는 데이터를 기록하며, [durable](https://docs.mongodb.com/manual/reference/glossary/#term-durable) 한 데이터를 checkpoint 에 남깁니다.

### Journal

WiredTiger 는 journal(write-ahead log) 를 이용하여 checkpoint 를 이용해 지속성을 데이터의 보장합니다.

Checkpoint 사이의 데이터는 journal 에 기록되며 재시작 등이 발생이 마지막 checkpoint 이후의 데이터는 journal 을 이용해 복원됩니다.

알림: MongoDB 4.0 부터 replica set 멤버에 대해 [--nojournal](https://docs.mongodb.com/manual/reference/program/mongod/#cmdoption-mongod-nojournal) 또는 [storage.journal.enabled: false](https://docs.mongodb.com/manual/reference/configuration-options/#storage.journal.enabled) 를 사용할 수 없습니다. 

### 압축

WiredTiger는 컬렉션과 인덱스에 대한 압축을 지원합니다. 압축은 CPU를 좀 더 사용해 저장소 용량을 줄입니다.

기본적으로 [snappy](https://docs.mongodb.com/manual/reference/glossary/#term-snappy) 라이브러리를 사용하며, 컬렉션을 위해 zlib, zstd 를 사용할 수도 있습니다.

### 메모리 사용

WiredTiger는 내부 캐시를 가지고 있습니다.

MongoDB 3.4 이후 기본 내부 캐시 크기는 (RAM - 1GB) 의 50%  또는 256MB 중 큰 값입니다.

### 스토리지 엔진 암호화

엔터프라이즈 버전에서는 스토리지 엔진 암호화를 지원합니다.

---

## 몽고디비 설치하기 실습(Community 버전)

1. 의존성 설치

```bash
sudo apt-get install libcurl4 openssl liblzma5
```

2. 배포용 압축파일 다운로드

```bash
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-4.4.3.tgz
```

3. 압축 풀기

```bash
tar zxvf mongodb-linux-x86_64-ubuntu2004-4.4.3.tgz
```

4. /usr/local/bin/ 으로 바이너리 복사

```bash
sudo cp mongodb-linux-x86_64-ubuntu2004-4.4.3/bin/* /usr/local/bin/
```

5. 공용 키 생성(주의: 실 서비스에는 보안 고려하여 키 생성하여야 함)

```bash
openssl rand -base64 741 > hueypark-key
```

6. mongod 1 실행(mongod_1.conf)

```yaml
storage:
  dbPath: /home/hueypark/mongodb/db/1
net:
  bindIp: localhost
  port: 27001
security:
  authorization: enabled
  keyFile: /home/hueypark/mongodb/hueypark-key
systemLog:
  destination: file
  path: /home/hueypark/mongodb/log/mongod1.log
  logAppend: true
processManagement:
  fork: true
replication:
  replSetName: hueypark-1
```

```bash
mongod --config mongod_1.conf
```

8. ... 실패 윈도우로 급 전환

9. mongod 1, 2, 3 실행

mongod_1.conf

```yaml
storage:
  dbPath: C:/Users/jaewa/mongodb/data/db/1
net:
  bindIp: localhost
  port: 27001
security:
  authorization: enabled
  keyFile: C:/Users/jaewa/mongodb/data/hueypark-key
systemLog:
  destination: file
  path: C:/Users/jaewa/mongodb/data/log/mongod1.log
  logAppend: true
replication:
  replSetName: hueypark
```

mongod_2.conf

```yaml
storage:
  dbPath: C:/Users/jaewa/mongodb/data/db/2
net:
  bindIp: localhost
  port: 27002
security:
  authorization: enabled
  keyFile: C:/Users/jaewa/mongodb/data/hueypark-key
systemLog:
  destination: file
  path: C:/Users/jaewa/mongodb/data/log/mongod2.log
  logAppend: true
replication:
  replSetName: hueypark
```

mongod_3.conf

```yaml
storage:
  dbPath: C:/Users/jaewa/mongodb/data/db/3
net:
  bindIp: localhost
  port: 27001
security:
  authorization: enabled
  keyFile: C:/Users/jaewa/mongodb/data/hueypark-key
systemLog:
  destination: file
  path: C:/Users/jaewa/mongodb/data/log/mongod3.log
  logAppend: true
replication:
  replSetName: hueypark
```

```bat
mongod --config mongod_1.conf
mongod --config mongod_2.conf
mongod --config mongod_3.conf
```

10. mongod 에 연결

```bash
mongo --port 27011
```

11. Replica set 초기화

```js
rs.initiate()
```

12. 관리자 유저 생성

```js
use admin

db.createUser({
  user: "hueypark-admin",
  pwd: "hueypark-pass",
  roles: [
    {role: "root", db: "admin"}
  ]
})
```

13. Shell에서 나온 후 관리자 유저로 재접속

```js
exit
```

```bash
mongo -port 27001 -u "hueypark-admin" -p "hueypark-pass" --authenticationDatabase "admin"
```

14. 다른 mongod Replica에 추가

```js
rs.add("localhost:27002")
rs.add("localhost:27003")
```

만약 Arbiter로 등록하고 싶다면 아래 함수를 사용

```js
rs.addArb("localhost:27003")
```

### 레퍼런스

- [Install MongoDB Community on Ubuntu using .tgz Tarball](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/)
- MongoDB University의 [M103 Basic Cluster Administration](https://university.mongodb.com/courses/M103/about)
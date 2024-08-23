---
title: "Bevy 101 - ECS 부터 itch.io 배포까지"
date: "2024-08-18"
tags: ["marsettler", "rust", "bevy", "game", "itchio", "github"]
layout: "slide"
draft: true
---

# Bevy 101 - ECS 부터 itch.io 배포까지

---

## 목차

- Bevy
- Bevy ECS
- itch.io
- itch.io 배포

---

## Bevy

- A refreshingly simple data-driven game engine built in Rust
- Free and Open Source Forever!

https://bevyengine.org/

---

- Data Driven
- 2D, 3D Renderer, Render Graph, Animation
- Cross Platform
- Bevy UI
- Scenes
- Sound
- Hot Reloading
- Productive Compile Times
- Free and Open Source

---

### Data Driven

All engine and game logic uses Bevy ECS, a custom Entity Component System

- Fast: Massively Parallel and Cache-Friendly. The fastest ECS according to some benchmarks
- Simple: Components are Rust structs, Systems are Rust functions
- Capable: Queries, Global Resources, Local Resources, Change Detection, Lock-Free Parallel Scheduler

---

```rust
#[derive(Component)]
struct Player;

fn system(
    q: Query<(Entity, &Player)>
) {
}
```

Bevy Component 와 System

일단 넘어가겠습니다.

---

## Bevy Hello World

```rust
use bevy::prelude::*;

fn main() {
    App::new()
        .add_systems(Startup, hello_world)
        .run();
}

fn hello_world() {
    println!("Hello World!");
}
```

---

## Bevy ECS

---

## 일반적인 ECS

---

## [Entity component system in wikipedia](https://en.wikipedia.org/wiki/Entity_component_system)

> Entity–component–system (ECS) is a software architectural pattern mostly used in video game development for the representation of game world objects.
>
> An ECS comprises entities composed from components of data, with systems which operate on the components.

---

## [Go 1.18 Generic으로 만들어본 ECS 시스템](https://www.youtube.com/watch?v=FylHURMCpPU&t=410s)

MVC 패턴과 비슷한 것 같기도 하지만

디커플링이 목적이 아니라

**성능 향상이 목적**

---

## [Bevy ECS](https://github.com/bevyengine/bevy/tree/main/crates/bevy_ecs)

### What is Bevy ECS?

> Bevy ECS is an Entity Component System custom-built for the Bevy game engine.
>
> It aims to be simple to use, ergonomic, fast, massively parallel, opinionated, and featureful.
>
> It was created specifically for Bevy's needs, but it can easily be used as a standalone crate in other projects

---

### ECS

> All app logic in Bevy uses the Entity Component System paradigm, which is often shortened to ECS.
> 
> ECS is a software pattern that involves breaking your program up into Entities, Components, and Systems.
>
> Entities are unique "things" that are assigned groups of Components, which are then processed using Systems.

---

### Concepts

---

#### Components

> Components are normal Rust structs.
>
> They are data stored in a World and specific instances of Components correlate to Entities.

```rust
use bevy_ecs::prelude::*;

#[derive(Component)]
struct Position { x: f32, y: f32 }
```

---

#### Entities

> Entities are unique identifiers that correlate to zero or more Components.

```rust
use bevy_ecs::prelude::*;

#[derive(Component)]
struct Position { x: f32, y: f32 }

#[derive(Component)]
struct Velocity { x: f32, y: f32 }

let mut world = World::new();

let entity_id = world
    .spawn((Position { x: 0.0, y: 0.0 }, Velocity { x: 1.0, y: 0.0 }))
    .id();

let entity_ref = world.entity(entity_id);
let position = entity_ref.get::<Position>().unwrap();
let velocity = entity_ref.get::<Velocity>().unwrap();
```

---

#### Systems

> Systems are normal Rust functions.
>
> Thanks to the Rust type system, Bevy ECS can use function parameter types to determine what data needs to be sent to the system.
>
> It also uses this "data access" information to determine what Systems can run in parallel with each other.

```rust
use bevy_ecs::prelude::*;

#[derive(Component)]
struct Position { x: f32, y: f32 }

fn print_position(query: Query<(Entity, &Position)>) {
    for (entity, position) in &query {
        println!("Entity {:?} is at position: x {}, y {}", entity, position.x, position.y);
    }
}
```


---

## [Build Your First Game in Bevy and Rust - Step by Step Tutorial](https://youtu.be/E9SzRc9HkOg)

OOP vs ECS

---

### OOP

```csharp
class Entity: Object {
    public int id;
    public Vector3 position;
    public Vector3 velocity;

    public void applyVelocity(float dt) {
        position += velocity * dt;
    }
}
```

---

### ECS

``` rust
// Entity
struct Entity {
    id: i32,
}

// Component
struct Transform {
    position: Vec3,
}

// System
fn velocity_system(
    query: Query<(&mut Transform, &Velocity)>) {
}
```

---

## 다른 엔진의 ECS 활용

---

### Unity

- [ECS for Unity](https://unity.com/ecs)
- [[ECS/DOTS #2] Unity ECS로 속도 향상, 캐릭터 5000개 만들어 보기](https://youtu.be/LVjb_fQs2J8)

---

### Unreal Engine

- [Engine Level ECS System Needed](https://forums.unrealengine.com/t/engine-level-ecs-system-needed/499939/2)

> TL;DR Unreal does take benefit of CPU threads.
> 
> It does already uses ECS where it makes sense, instead of forcing everyone to some trend.

---

## 자 이제 Bevy 로 게임을 만들었습니다.

## 그 다음은? 배포!

---

## 주요 고려사항

1. 사용자에게 가깝다. 
2. 쉽게 사용할 수 있다.
3. 개발자의 노력이 적다.

---

- Google Play
- App Store
- Steam
- 자체 배포
- ...

---

## itch.io

> itch.io is an open marketplace for independent digital creators with a focus on independent video games.

https://itch.io/docs/general/about

---

## Snake v2

https://hueypark.itch.io/snake-v2

---

## itch.io 배포 with bevy

https://github.com/hueypark/marsettler/blob/b0a93930b057b9c9141b36dd8d9c891c275da456/.github/workflows/release.yaml

## GitHub Actions workflow

1. Checkout code

```
- name: Checkout code
  uses: actions/checkout@v4
```

## 참고자료

- [Go 1.18 Generic으로 만들어본 ECS 시스템 (공봉식님)](https://www.youtube.com/watch?v=FylHURMCpPU&t=410s)
- [Bevy ECS](https://github.com/bevyengine/bevy/tree/main/crates/bevy_ecs)
- [Bevy Quickstart](https://github.com/TheBevyFlock/bevy_quickstart)

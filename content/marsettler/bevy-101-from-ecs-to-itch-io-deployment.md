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

---

## 일반적인 ECS

[Entity component system](https://en.wikipedia.org/wiki/Entity_component_system)

---

[Go 1.18 Generic으로 만들어본 ECS 시스템 (공봉식님)](https://www.youtube.com/watch?v=FylHURMCpPU&t=410s)

MVC 패턴과 비슷한 것 같기도 하지만

디커플링이 목적이 아니라

### 성능 향상이 목적

---

## Bevy ECS

- https://github.com/bevyengine/bevy/tree/main/crates/bevy_ecs

---

[Build Your First Game in Bevy and Rust - Step by Step Tutorial](https://youtu.be/E9SzRc9HkOg)

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

- [ECS for Unity](https://unity.com/ecs)

- [Engine Level ECS System Needed](https://forums.unrealengine.com/t/engine-level-ecs-system-needed/499939/2)

> TL;DR Unreal does take benefit of CPU threads. It does already uses ECS where it makes sense, instead of forcing everyone to some trend.

---

## itch.io

itch.io is an open marketplace for independent digital creators with a focus on independent video games.

https://itch.io/docs/general/about

---

## itch.io 배포 with bevy

https://github.com/hueypark/marsettler/blob/b0a93930b057b9c9141b36dd8d9c891c275da456/.github/workflows/release.yaml

## GitHub Actions workflow

1. Checkout code

```
- name: Checkout code
  uses: actions/checkout@v4
```
---
title: "etcd"
date: "2022-06-07"
tags: ["database", "etcd", "distributed system"]
draft: true
---

A distributed, reliable key-value store for the most critical data of a distributed system

## What is etcd?

etcd is a strongly consistent, distributed key-value store that provides a reliable way to store data that needs to be accessed by a distributed system or cluster of machines. It gracefully handles leader elections during network partitions and can tolerate machine failure, even in the leader node.

## Features

### Simple interface

Read and write values using standard HTTP tools, such as curl

### Key-value storage

Store data in hierarchically organized directories, as in a standard filesystem

### Watch for changes

Watch specific keys or directories for changes and react to changes in values

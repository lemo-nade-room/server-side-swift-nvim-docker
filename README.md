# Server-Side SwiftをNeovimで開発するためのDocker環境

## ベースイメージ

Ubuntu:24.04

## ユーザー

- swiftlover
  - ホームディレクトリ: /swiftlover
  - 一般ユーザー
  - sudo
- root
    - ホームディレクトリ: /root
  - 特権ユーザー

## インストール済みツール

- Swift 6.1.2
- Git 2.43.0
- gh 2.74.0
- Vapor 19.1.1
- Homebrew 4.5.3
- Swiftly 1.0.0
- Neovim 0.11.2

## 使用例

### コンテナを起動

```shell
docker compose up -d
```

### コンテナに入る

```shell
docker compose exec dev bash
```

### プロジェクト作成

```bash
vapor new Hello -n
```

### Neovimで開く

```bash
cd Hello
nvim Package.swift
```

### Neovim上でターミナルを開く

Spaceを押した後、tを2回押す

```bash
swift build
```

### Neovim上でターミナルから離れる

エスケープを2回おす

### Neovim上でターミナルに戻る

ウィンドウ切り替え

Ctrl+wを押した後、w

### Neovim上でディレクトリtreeへ移動する

Spaceを押したあとe

#!/usr/bin/env bash
# 環境変数 GIT_USER_NAME, GIT_USER_EMAIL を使ってグローバル設定を行う

# 必須チェック
if [ -z "${GIT_USER_NAME}" ] || [ -z "${GIT_USER_EMAIL}" ]; then
  echo "エラー: 環境変数 GIT_USER_NAME または GIT_USER_EMAIL が設定されていません。" >&2
  exit 1
fi

git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"
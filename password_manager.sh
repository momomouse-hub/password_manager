#!/bin/bash

echo "パスワードマネージャーへようこそ！"
read -p "サービス名を入力してください:" service_name
read -p "ユーザー名を入力してください:" user_name
read -p "パスワードを入植してください:" password

echo "$service_name:$user_name:$password" >> passwords.txt

echo "Thank you!"

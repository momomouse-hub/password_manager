#!/bin/bash

echo "パスワードマネージャーへようこそ"
read -p "次の選択肢から入力してください(Add Password/Get Password/Exit):" choice

while [ "$choice" != "Exit" ]
do
	if [ "$choice" = "Add Password" ]; then
		read -p "サービス名を入力してください:" service_name
		read -p "ユーザー名を入力してください:" user_name
		read -p "パスワードを入力してください:" password
		gpg --decrypt passwords.txt.gpg > passwords.txt #復号化
		echo "$service_name:$user_name:$password" >> passwords.txt #一時ファイル(passwords.txtに追記)
		gpg --symmetric passwords.txt #暗号化
		rm passwords.txt #一時ファイル削除
		echo "パスワードの追加は成功しました。"
	elif [ "$choice" = "Get Password" ]; then
		read -p "サービス名を入力してください:" searching_service_name
		if gpg --decrypt passwords.txt.gpg | grep -q "^${searching_service_name}:"; then #サービス名が部分一致でも反応するようになっていたので:追加 #復号データを標準出力へ
			for hit in $(gpg --decrypt passwords.txt.gpg | grep "^${searching_service_name}") #復号データを標準出力へ
			do
				hit1=$(echo "$hit" | cut -d : -f 1)
				hit2=$(echo "$hit" | cut -d : -f 2)
				hit3=$(echo "$hit" | cut -d : -f 3)
				echo "サービス名が見つかりました。"
				echo "サービス名:$hit1"
				echo "ユーザー名:$hit2"
				echo "パスワード:$hit3"
			done
		else
			echo "そのサービスは登録されていません。"
		fi

	else
		echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
	fi

	read -p "次の選択肢から入力してください(Add Password/Get Password/Exit):" choice
done

echo "Thank you!"

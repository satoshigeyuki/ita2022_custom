# 「アルゴリズム入門」(2022A) の課題作成キット

## 準備

### ソフトウェア環境

* `sh` や `make` が使えるUnix環境．
  + WSL2上のUbuntu {20,22}.04 (LTS)で動作確認済み．
* Python環境：
  + Python 3.8以上（コマンド `python3` で呼び出せるようにする）
  + [`ipykernel`](https://pypi.org/project/ipykernel/)
  + 模範解答が用いるパッケージ（例：[`ita`](https://pypi.org/project/ita/)）

### ワーキングディレクトリ

1. このレポジトリをcloneする．
2. submoduleの `plags_scripts` レポジトリの中身を取ってくる．

```sh
git submodule update --init
```

以降では，このレポジトリのトップレベルディレクトリが，カレントディレクトリであると仮定する．

## 課題作成の手順

### ビルド

1. `masters` に問題文のみを記述したipynbファイル（master）を置く．
   * 以降ではmasterを `${exercise_key}.ipynb` とし，課題名を `${exercise_key}` とする．
   * `${exercise_key}` は正規表現 `[a-zA-Z0-9_-]{1,64}` にマッチする文字列であるとする．
2. `make` を実行．
   * `masters/${exercise_key}.py` が無ければ作られる．
      + 解答セルに最初から入っている（prefill）コード．
   * 自動評価のテストモジュール用ディレクトリ `tests/${exercise_key}` が無ければ作られる．
3. Prefillコード `masters/${exercise_key}.py` を編集（必要に応じて）．
4. テストモジュールを設置．
   * `tests/${exercise_key}` に設置するPythonモジュールの名前は自由．
   * 複数設置すると，モジュール名の順にステージ化して実行される．
5. `make` を実行．
   * 受講生に配布するform `forms/${exercise_key}.ipynb` が作られる．
   * PLAGS UTにアップロード可能な `conf.zip` が作られる．

#### Tips

ビルドの試行には `plags_scripts/exercises` を使うと手際が良い．

```
cp plags_scripts/exercises/as-is/ex2.ipynb masters/
make
cp plags_scripts/exercises/as-is/test_ex2.py tests/ex2/
make
```

### テスト

6. `make test` を実行．
   * `answers/${exercise_key}.py` が無ければ作られる．
7. 解答例 `answers/${exercise_key}.py` を編集．
8. `make test` を実行．
   * 解答例のテスト結果をまとめた `results/${exercise_key}.ipynb` が作られる．

#### Tips

`answers` には模範解答を置き，誤答例を別ディレクトリ（例えば `wrong_answers`）に置くと便利である．
このとき，誤答例をテストするときには `make ANSWER_DIR=wrong_answers test` を実行すればよい．

## デプロイ用設定ファイル

* `judge_env.json`: 自動評価のサーバ側の設定が記述されている管理者指定のファイル．**変更禁止**．

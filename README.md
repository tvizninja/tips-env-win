# Tips for my Windows environment.

* 自身の環境(Windows)と関係アプリ環境などでのTipsのメモ

## QGIS関係

* QGISインストール環境で、GDALコマンドをPowershellで回したい、(QGISでインストールされる)Pythonを使ってコマンド実行したい
  * [qgisenv-ps.bat](qgis/qgisenv-ps.bat) : 6行目以降にPowershellを書く。 gdalinfoなど各種コマンドが利用可能(OSGeo4Wの各種パスが通った状態)
  * [qgisenv-py.bat](qgis/qgisenv-py.bat) : 14行目以降にPythonを書く(必要に応じて各種ライブラリをインポート)。
  * 雑にQGISのパスを探しているので、複数QGISがインストールされていると、古い方が使われてしまうかも

* OSGeo4W.bat環境下でのpythonでTab補完が効かない
  * 詳細は<https://qiita.com/cabbage_lettuce/items/4b662801543caee7e6b0>を参照
  * `pip install pyreadline`
  * `%appdata%Python\Python39\site-packages` に `usercustomize.py` を作成(内容は上記記事参照)
  * `%appdata%Python\Python39\site-packages` の `readline.py` に `redisplay = lambda: None` を追記

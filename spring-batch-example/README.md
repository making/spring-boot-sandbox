# Spring Batch Example

## Fileを読み込んでDBへ保存するバッチ

```
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.batch.job.names=FileToDb"
```

invalidな行を含むファイルを読み込む(`Application finished with exit code: 6`)。

```
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.batch.job.names=FileToDb input.file=inputs/input-invalid.csv"
```

入力ファイルが存在しない場合(`Application finished with exit code: 5`)。

```
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.batch.job.names=FileToDb input.file=input-not-exists.csv"
```

#Python利用SQLAlchemy从mysql数据库自动生成models
import sqlacodegen

username="root"
password="root"
dbname = "share"

sqlacodegen "mysql+oursql://username:password@localhost/dbname"
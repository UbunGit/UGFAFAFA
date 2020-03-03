from models import db, create_app
from models.models import *
 
 
app = create_app()
app_ctx = app.app_context()  # app_ctx = app/g
with app_ctx:  # __enter__,通过LocalStack放入Local中
    db.create_all()  # 调用LocalStack放入Local中获取app，再去app中获取配置
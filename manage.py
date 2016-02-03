#! /usr/bin/env python

import os

from flask.ext.script import Manager

from app import create_app, db

from flask_migrate import Migrate, MigrateCommand


app = create_app(os.getenv('APP_CONFIG', 'default'))
manager = Manager(app)
migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

def get_db_url():
    return str(db.engine.url)


@manager.shell
def make_shell_context():
    return dict(app=app, db=db)


if __name__ == '__main__':
    manager.run()

#! /usr/bin/env python

import os

from flask.ext.script import Manager, Server

from app import create_app, db

from flask_migrate import Migrate, MigrateCommand

from flask import render_template


app = create_app(os.getenv('APP_CONFIG', 'default'))
manager = Manager(app)
migrate = Migrate(app, db)

manager.add_command('db', MigrateCommand)

manager.add_command("runserver", Server(host='0.0.0.0'))

def get_db_url():
    return str(db.engine.url)


@manager.shell
def make_shell_context():
    return dict(app=app, db=db)

@app.route('/')
def app_home():
    return render_template('index.html')


if __name__ == '__main__':
    manager.run()

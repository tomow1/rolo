from flask import jsonify, request, abort

from . import api
from .. import db
from ..models.task import Task
from ..schemas.task import task_schema, tasks_schema
import json
import datetime
from sqlalchemy import null


@api.route('/tasks', methods=['GET'])
def get_tasks():
    entities = Task.query.all()
    return json.dumps([entity.to_dict() for entity in entities])
    # return tasks_schema.dumps(entity)


@api.route('/tasks/<int:id>', methods=['GET'])
def get_task(id):
    entity = Task.query.get(id)
    if not entity:
        abort(404)
    return json.dumps(entity.to_dict())


@api.route('/tasks', methods=['POST'])
def create_task():
    entity = Task(
        name = request.json['name']
        , completed = False
        #, dateAdded = datetime.datetime.strptime(request.json['dateAdded'], "%Y-%m-%d").date()
        , dateAdded = datetime.datetime.now().date()
        , datePlanned = None
        , dateCompleted = None
    )
    db.session.add(entity)
    db.session.commit()
    return jsonify(entity.to_dict()), 201
    # return task_schema.dumps(entity), 201


@api.route('/tasks/<int:id>', methods=['PUT'])
def update_task(id):
    entity = Task.query.get(id)
    if not entity:
        abort(404)
    entity = Task(
        name = request.json['name'],
        completed = request.json['completed'],
        dateAdded = datetime.datetime.strptime(request.json['dateAdded'], "%Y-%m-%d").date(),
        datePlanned = datetime.datetime.strptime(request.json['datePlanned'], "%Y-%m-%d").date() if request.json['datePlanned'] is not None else None,
        dateCompleted = datetime.datetime.strptime(request.json['dateCompleted'], "%Y-%m-%d").date() if request.json['dateCompleted'] is not None else None,
        id = id
    )
    db.session.merge(entity)
    db.session.commit()
    return jsonify(entity.to_dict()), 200


@api.route('/tasks/<int:id>', methods=['DELETE'])
def delete_task(id):
    entity = Task.query.get(id)
    if not entity:
        abort(404)
    db.session.delete(entity)
    db.session.commit()
    return '', 204

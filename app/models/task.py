from .. import db


class Task(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    # Additional fields

    name = db.Column(db.String)
    completed = db.Column(db.Boolean)
    dateAdded = db.Column(db.Date)
    datePlanned = db.Column(db.Date)
    dateCompleted = db.Column(db.Date)


    def to_dict(self):
        return dict(
            name = self.name,
            completed = self.completed,
            dateAdded = self.dateAdded.isoformat(),
            datePlanned = self.datePlanned.isoformat() if self.datePlanned is not None else None,
            dateCompleted = self.dateCompleted.isoformat() if self.dateCompleted is not None else None,
            id = self.id
        )


    def __repr__(self):
        return 'Task {}>'.format(self.id)

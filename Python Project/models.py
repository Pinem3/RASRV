from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'User'

    user_id = db.Column('User ID', db.Integer, primary_key=True, autoincrement=True)
    username = db.Column('Username', db.String(64), nullable=False)
    password = db.Column('Password', db.String(64), nullable=False)
    position = db.Column('Position', db.String(20), nullable=False)
    system_entry = db.Column('System Entry', db.DateTime, nullable=False)
    system_exit = db.Column('System Exit', db.DateTime, nullable=False)

    productions = db.relationship('Production', backref='user', lazy=True)


class Process(db.Model):
    __tablename__ = 'Process'

    process_id = db.Column('Process ID', db.Integer, primary_key=True, autoincrement=True)
    name = db.Column('Name', db.String(20), nullable=False)
    status = db.Column('Status', db.Integer, nullable=False)
    duration = db.Column('Duration', db.Integer, nullable=False)

    productions = db.relationship('Production', backref='process', lazy=True)


class Material(db.Model):
    __tablename__ = 'Materials'

    material_id = db.Column('Material ID', db.Integer, primary_key=True, autoincrement=True)
    name = db.Column('Material name', db.String(64), nullable=False)
    count = db.Column('Count', db.Integer, nullable=False)

    productions = db.relationship('Production', backref='material', lazy=True)


class Equipment(db.Model):
    __tablename__ = 'Equipment'

    equipment_id = db.Column('Equipment ID', db.Integer, primary_key=True, autoincrement=True)
    status = db.Column('Status', db.String(20), nullable=False)
    name = db.Column('Name', db.String(64), nullable=False)
    equipment_class = db.Column('Class', db.String(64), nullable=False)

    productions = db.relationship('Production', backref='equipment', lazy=True)


class Production(db.Model):
    __tablename__ = 'Production'

    production_id = db.Column('Production ID', db.Integer, primary_key=True, autoincrement=True)
    material_id = db.Column('Material ID', db.Integer, db.ForeignKey('Materials.Material ID'), nullable=False)
    name = db.Column('Name', db.String(64), nullable=False)
    equipment_id = db.Column('Equipment ID', db.Integer, db.ForeignKey('Equipment.Equipment ID'), nullable=False)
    process_id = db.Column('Process ID', db.Integer, db.ForeignKey('Process.Process ID'), nullable=False)
    user_id = db.Column('User ID', db.Integer, db.ForeignKey('User.User ID'), nullable=False)

    logs = db.relationship('Log', backref='production', lazy=True)


class Log(db.Model):
    __tablename__ = 'Logs'

    log_id = db.Column('Logs ID', db.Integer, primary_key=True, autoincrement=True)
    timestamp = db.Column('Timestamp', db.DateTime, nullable=False)
    content = db.Column('Content', db.String(256), nullable=False)
    type = db.Column('Type', db.String(32), nullable=False)
    production_id = db.Column('Production ID', db.Integer, db.ForeignKey('Production.Production ID'), nullable=False)
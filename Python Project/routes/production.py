from flask import Blueprint, request, jsonify
from models import db, Production, Material, Equipment, Process, User

production_bp = Blueprint('production', __name__)


@production_bp.route('/production', methods=['GET'])
def get_production():
    productions = db.session.query(
        Production,
        Material.name.label('material_name'),
        Equipment.name.label('equipment_name'),
        Process.name.label('process_name'),
        User.username
    ).join(
        Material, Production.material_id == Material.material_id
    ).join(
        Equipment, Production.equipment_id == Equipment.equipment_id
    ).join(
        Process, Production.process_id == Process.process_id
    ).join(
        User, Production.user_id == User.user_id
    ).all()

    result = []
    for prod, mat_name, eq_name, proc_name, username in productions:
        result.append({
            'productionId': prod.production_id,
            'name': prod.name,
            'material': mat_name,
            'equipment': eq_name,
            'process': proc_name,
            'user': username
        })

    return jsonify(result)
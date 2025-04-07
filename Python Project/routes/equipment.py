from flask import Blueprint, request, jsonify
from models import db, Equipment

equipment_bp = Blueprint('Equipment', __name__)


@equipment_bp.route('/equipment', methods=['GET'])
def get_equipment():
    equipment_list = Equipment.query.all()
    return jsonify([{
        'equipmentId': eq.equipment_id,
        'status': eq.status,
        'name': eq.name,
        'class': eq.equipment_class
    } for eq in equipment_list])


@equipment_bp.route('/equipment', methods=['POST'])
def add_equipment():
    data = request.get_json()
    new_equipment = Equipment(
        equipment_id=data['equipmentID'],
        status=data['status'],
        name=data['name'],
        equipment_class=data['class']
    )
    db.session.add(new_equipment)
    db.session.commit()
    return jsonify({'message': 'Equipment added successfully'}), 201


@equipment_bp.route('/equipment/<int:equipment_id>', methods=['PUT'])
def update_equipment(equipment_id):
    equipment = Equipment.query.get_or_404(equipment_id)
    data = request.get_json()

    equipment.status = data.get('status', equipment.status)
    equipment.name = data.get('name', equipment.name)
    equipment.equipment_class = data.get('class', equipment.equipment_class)

    db.session.commit()
    return jsonify({'message': 'Equipment updated successfully'})


@equipment_bp.route('/equipment/<int:equipment_id>', methods=['DELETE'])
def delete_equipment(equipment_id):
    equipment = Equipment.query.get_or_404(equipment_id)
    db.session.delete(equipment)
    db.session.commit()
    return jsonify({'message': 'Equipment deleted successfully'})
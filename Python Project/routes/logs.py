from flask import Blueprint, request, jsonify
from models import db, Log
from datetime import datetime

logs_bp = Blueprint('logs', __name__)


@logs_bp.route('/logs', methods=['GET'])
def get_logs():
    production_id = request.args.get('productionId')

    query = Log.query.order_by(Log.timestamp.desc())

    if production_id:
        query = query.filter_by(production_id=production_id)
    else:
        query = query.limit(100)

    logs = query.all()

    return jsonify([{
        'logId': log.log_id,
        'timestamp': log.timestamp.isoformat(),
        'content': log.content,
        'type': log.type,
        'productionId': log.production_id
    } for log in logs])
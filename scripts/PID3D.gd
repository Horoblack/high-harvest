extends RefCounted
class_name PID3D

var _p : float
var _i : float
var _d : float

var _preverror : Vector3
var _errorintegral : Vector3

func _init(p:float,i:float,d:float):
	_p = p
	_i = i
	_d = d

func update(error:Vector3,delta:float)->Vector3:
	_errorintegral += error*delta
	var errorderivative = (error-_preverror)/delta
	_preverror = error
	return _p*error * _i * _errorintegral * _d * errorderivative

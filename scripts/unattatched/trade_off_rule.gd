extends RefCounted
class_name TradeOffRule

var parameters: Array[ParameterDef]

func calc_total(values: Dictionary) -> int:
	var sum: int = 0
	for p in parameters:
		if not p.is_trade_off:
			continue
		sum += p.to_level(values[p.name])
	return sum

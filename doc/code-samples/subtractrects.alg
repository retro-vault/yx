algorithm SubtractRects
input:  Outer rectangle A
		Inner rectangle B
output: List of rectangles An
begin
	if A.y1 < B.y0
		A1 ← (A.x0, A.y0, A.x1, B.y0)
		add A1 to An 
	if B.y1 < A.y1
		A4 ← (A.x0, B.y1, A.x1, A.y1)
		add A1 to An
	if A.x0 < B.x0
		A2 ← (A.x0, B.y0, B.x0, B.y1)
		add A2 to An
	if B.x1 < A.x1
		A3 ← (B.x1, B.y0, A.x1, B.y1)
		add A3 to An
	return An
end

algorithm GetRectsIntersect
input:	Rectangle A
		Rectangle B
output:	Answer Intersect
		Answer yes/no
begin
	if call RectsOverlap(A,B) 
		Intersect.x0 ← max(A.x0,B.x0), Intersect.y0 ← max(A.y0,B.y0)
		Intersect.x1 ← min(A.x1,B.x1), Intersect.y1 ← min(A.y1,B.y1)
		return yes
	else return no
end
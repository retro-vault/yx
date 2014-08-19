algorithm RectsOverlap
input:	Rectangle A
		Rectangle B
output:	Answer yes/no
begin
	return !(A.y1 < B.y0 || A.y0 > B.y1 || A.x1 < B.x0 || A.x0 > B.x1) 
end

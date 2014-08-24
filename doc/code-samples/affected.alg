algorithm FindAffectedWindowsRectangles
input:	Z-ordered WindowsList
		Rectangle Area
output:	Messages sent to all affected windows
begin
	if Area is null return
	Window ← top window from WindowsList
	IntersectRect ← intersection between Area and Window
	if exists IntersectRect
		send repaint message to Window for IntersectRect
		remove Window from WindowsList
	if WindowsList is empty return
	SmallerAreas ← call SubtractRects(IntersectRect, Area)
	foreach SmallerArea in SmallerAreas 
		call FindAffectedWindowsRectangles(WindowsList, SmallerArea)
end

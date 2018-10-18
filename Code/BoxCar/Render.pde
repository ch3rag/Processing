void drawBody(Body body) {

	Vec2 bodyPos = box2d.getBodyPixelCoord(body);
	float angle = body.getAngle();
	pushMatrix();
	translate(bodyPos.x, bodyPos.y);
	rotate(-angle);
	
	for(Fixture f = body.getFixtureList(); f != null ; f = f.getNext()) {
		color c = (color)f.getUserData();
		
		fill(c);
		stroke(c/2);
		strokeWeight(1);
		
		switch(f.getType()) {
			case POLYGON:
				PolygonShape ps = (PolygonShape) f.getShape();
				beginShape();
				for (int i = 0 ; i < ps.getVertexCount() ; i++) {
						Vec2 vtx = box2d.vectorWorldToPixels(ps.m_vertices[i]);
						vertex(vtx.x, vtx.y);
				}
				endShape(CLOSE);
				break;

			case CIRCLE:
				CircleShape cs = (CircleShape) f.getShape();
				Vec2 center = box2d.vectorWorldToPixels(cs.m_p);
				float radius = box2d.scalarWorldToPixels(cs.m_radius);
				ellipse(center.x, center.y, radius * 2, radius * 2);
				line(0, 0, radius, 0);
				break;
			
			default : break;	
		}
	}

	popMatrix();
}
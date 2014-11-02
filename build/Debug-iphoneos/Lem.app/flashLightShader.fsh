uniform vec2 lightPos;
uniform float lightDirection;
uniform float levelZoom;
uniform vec2 levelSize;

bool isPointInTriangle(in vec2 P, in vec2 A, in vec2 B, in vec2 C);


////// code to test if a point is in a triangle.
bool isPointInTriangle(in vec2 P, in vec2 A, in vec2 B, in vec2 C) {
    
    ///compute 3 vectors.
    // p1 is reference point.
    vec2 v0 = C - A;
    vec2 v1 = B - A;
    vec2 v2 = P - A;
    
    //compute dot products
    float dot00 = dot(v0, v0);
    float dot01 = dot(v0, v1);
    float dot02 = dot(v0, v2);
    float dot11 = dot(v1, v1);
    float dot12 = dot(v1, v2);
    
    
    ///reused denominator
    float denom =  1.0 / (dot00 * dot11 - dot01 * dot01);
    
    float value1 = (dot11 * dot02 - dot01 * dot12) * denom;
    float value2 = (dot00 * dot12 - dot01 * dot02) * denom;
    float value3 = value1 + value2;
    return (value1 >= 0.0) && (value2 >= 0.0) && (value1 + value2 < 1.0);
    
}


void main() {
    
    
    ////////// - TEST IF A POINT IS WITHIN OUR LIGHT CONE SHAPE...
    vec2 texCoord = cc_FragTexCoord1;
    vec2 testPointDistance = texCoord * cc_ViewSizeInPixels * (levelSize / cc_ViewSizeInPixels); //// the last y value has to be 1 since those are relatively the same.
    testPointDistance = vec2(testPointDistance.x, levelSize.y - testPointDistance.y);
    
    
    float coneRadius = 600.0 * lightDirection * levelZoom; ///multiply both values by the level zoom. so the cone becomes equally bigger.
    float coneWidthHalf = 321.0 * levelZoom;
    
    vec2 trianglePoint1 = lightPos;
    vec2 trianglePoint2 = trianglePoint1 + vec2(coneRadius, coneWidthHalf);
    vec2 trianglePoint3 = trianglePoint1 + vec2(coneRadius, -coneWidthHalf);
    
    float startingDarkness = 0.1;
    float triangleDarkness;
    
    float rDist = coneRadius;
    float xDist = (trianglePoint1.x + coneRadius) - testPointDistance.x;
    triangleDarkness = xDist / rDist;
    
    
    vec4 texColor = texture2D(cc_MainTexture, cc_FragTexCoord1); /////for some reason the placement of this line of code is veryyyyy important...
    
    float actualDarkness = startingDarkness;
    
    if (  (isPointInTriangle(testPointDistance, trianglePoint1, trianglePoint2, trianglePoint3)) == true   ) {
        
        actualDarkness = triangleDarkness + startingDarkness;
        
    }
    
    
    //vec3 newColor = vec3(texColor.r * actualDarkness, texColor.g * actualDarkness, texColor.b * actualDarkness);
    vec3 mult = vec3(actualDarkness, actualDarkness, actualDarkness);
    vec3 newColor = texColor.rgb * mult;
    
    gl_FragColor = vec4(newColor, texColor.a);
}


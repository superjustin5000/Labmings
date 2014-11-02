
uniform sampler2D pauseEffectMask;

void main() {
    
    vec2 texCoord = cc_FragTexCoord1;
    vec4 curPos = gl_FragCoord;
    
    vec4 pauseEffectMaskColor = texture2D(pauseEffectMask, texCoord);
    
    float time = cc_Time[0];
    
    float speed = 20.0;
    float distortX;
    if (pauseEffectMaskColor.a == 0.0) {
        distortX =  0.5;   ///////////// the mask value of alpha 0 should have some insane distorition to produce a line?
    }
    else {
        distortX = (0.04 * (pauseEffectMaskColor.a * pauseEffectMaskColor.a)) + 0.01 * cc_Random01.x; //// distort using the mask....   ///add a bit of randomness.
    }
    float distortY = 1000.0;////biger number = smaller height
    
    texCoord.x += distortX * sin( distortY * texCoord.y + (time * speed) );
    
    gl_FragColor = cc_FragColor * texture2D(cc_MainTexture, texCoord);
    
}
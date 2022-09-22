#version 300 es

#ifdef GL_ES
precision mediump float;
#endif

in vec2 fs_UV;
in float fs_Time;

out vec4 out_Col;

Add Background Shader

void main() {
    out_Col = colorizeBack();
<<<<<<< HEAD
}
=======
}
>>>>>>> 826f5f9b5c46393d2e575180c584de382b59db0c

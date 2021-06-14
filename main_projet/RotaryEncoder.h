#ifndef __ROTARY_ENCODER__H
#define __ROTARY_ENCODER__H

class RotaryEncoder {
public :
    bool a, b, button;

    RotaryEncoder() {}
    ~RotaryEncoder() {}

    void setup(bool isPulledup) {
        pullup = isPulledup;
        a = pa = pullup;
        b = pb = pullup;
        button = pbutton = pullup;
    }

    // to be called on every loop, return a code representing transitions
    // 0 : no transition
    // 1 : clockwise
    // 2 : anticlockwise
    // 4 : push button released
    // for example : 6 = anticlockwise + pushbutton
    unsigned int update(bool _a, bool _b, bool _button = true) {
        pa = a;
        pb = b;
        pbutton = button;

        a = _a;
        b = _b;
        button = _button;

        unsigned int code = 0;
        if((a && !pa && !b) || (!a && pa && b) || (b && !pb && a) || (!b && pb && !a)) { // clockwise if pullup
            if(pullup)
                code += 1;
            else
                code += 2;
        }
        if((a && !pa && b) || (!a && pa && !b) || (b && !pb && !a) || (!b && pb && a)) { // anticlockwise if pullup
            if(pullup)
                code += 2;
            else
                code += 1;
        }
        if(button && !pbutton) { // button released
            code += 4;
        }
        return code;
    }

private :
    bool pullup;
    bool pa, pb, pbutton;
};

#endif // __ROTARY_ENCODER__H



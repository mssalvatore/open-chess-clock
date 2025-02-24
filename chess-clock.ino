#include <Keyboard.h>
const int debounce = 5;

const int LEFT_SWITCH = 3;
const int RIGHT_SWITCH = 2;

const int IDLE=0;
const int PAUSE = 1;
const int PAUSE_LEFT = 2;
const int PAUSE_RIGHT = 3;
const int LEFT_DOWN = 4;
const int RIGHT_DOWN = 5;

int current_state = IDLE;

const int LEFT_KEY_SEQUENCE[] = {KEY_DOWN_ARROW, KEY_DOWN_ARROW, KEY_LEFT_ARROW, KEY_RETURN};
const int LEFT_KEY_SEQUENCE_SIZE = sizeof(LEFT_KEY_SEQUENCE) / sizeof(LEFT_KEY_SEQUENCE[0]);
const int RIGHT_KEY_SEQUENCE[] = {KEY_DOWN_ARROW, KEY_DOWN_ARROW, KEY_RIGHT_ARROW, KEY_RETURN};
const int RIGHT_KEY_SEQUENCE_SIZE = sizeof(RIGHT_KEY_SEQUENCE) / sizeof(RIGHT_KEY_SEQUENCE[0]);

void setup() {
  pinMode(LEFT_SWITCH, INPUT_PULLUP);
  pinMode(RIGHT_SWITCH, INPUT_PULLUP);

  Keyboard.begin();

}

int debounce_read(int pin) {
  if (digitalRead(pin) == LOW) {
    delay(debounce);
    return digitalRead(pin);
  }

  return HIGH;
}

void press_keys(int keys[], int num_keys) {
    for (int i = 0; i < num_keys; i++) {
        Keyboard.write(keys[i]);
        delay(10);
    }
}

void press_left() {
    press_keys(LEFT_KEY_SEQUENCE, LEFT_KEY_SEQUENCE_SIZE);
}

void press_right() {
    press_keys(RIGHT_KEY_SEQUENCE, RIGHT_KEY_SEQUENCE_SIZE);
}

void pause() {
    // NOP
}


void loop() {
    if (debounce_read(LEFT_SWITCH) == LOW) {
        if (current_state == IDLE) {
            press_left();
            current_state = LEFT_DOWN;
        }
        else if (current_state == RIGHT_DOWN) {
            pause();
            current_state = PAUSE;
        }
        else if (current_state == PAUSE_RIGHT) {
            current_state = PAUSE;
        }
    }
    else {
        if (current_state == LEFT_DOWN || current_state == PAUSE_LEFT) {
            current_state = IDLE;
        }
        else if (current_state == PAUSE) {
            current_state = PAUSE_RIGHT;
        }
    }

    if (debounce_read(RIGHT_SWITCH) == LOW) {
        if (current_state == IDLE) {
            press_right();
            current_state = RIGHT_DOWN;
        }
        else if (current_state == LEFT_DOWN) {
            pause();
            current_state = PAUSE;
        }
        else if (current_state == PAUSE_LEFT) {
            current_state = PAUSE;
        }
    }
    else {
        if (current_state == RIGHT_DOWN || current_state == PAUSE_RIGHT) {
            current_state = IDLE;
        }
        else if (current_state == PAUSE) {
            current_state = PAUSE_LEFT;
        }
    }

    delay(5);
}

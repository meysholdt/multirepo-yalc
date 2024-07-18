#!/bin/bash

(cd lib
    npm install
    yalc publish
)
(cd app
    npm install
    yalc add lib
    npm install
)
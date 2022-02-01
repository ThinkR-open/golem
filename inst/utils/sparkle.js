// From https://gist.github.com/averykhoo/8057a0324be445bd7eea32c89379eb76

const star = [];
const star_x = [];
const star_y = [];
const star_remaining_ticks = [];
const tiny = [];
const tiny_x = [];
const tiny_y = [];
const tiny_remaining_ticks = [];
const sparkles = 250; // total number of stars, same as number of dots
const sparkle_lifetime = 30; // each star lives for twice this, then turns into a dot that also lives twice this
const sparkle_distance = 30; // pixels

// need to cache this because checking document size is slow
let doc_height;
let doc_width;
let sparkles_enabled = null;

// runs AFTER document.addEventListener("DOMContentLoaded", function () {...});
window.onload = function() {

    // cache doc size
    doc_height = document.documentElement.scrollHeight;
    doc_width = document.documentElement.scrollWidth;

    // start animation loop
    animate_sparkles();
    if (sparkles_enabled === null) {
        sparkle(true);
    }
};

// start / stop / toggle the sparkles
function sparkle(enable = null) {
    if (enable === null) {
        sparkles_enabled = !sparkles_enabled;
    } else {
        sparkles_enabled = !!enable;
    }

    if (sparkles_enabled && star.length < sparkles) {
        sparkle_init();
    }
}


// initialize but only if called
function sparkle_destroy() {

    let elem;
    while (tiny.length) {
        elem = tiny.pop();
        if (elem) {
            document.body.removeChild(elem);
        }
    }

    while (star.length) {
        elem = star.pop();
        if (elem) {
            document.body.removeChild(elem);
        }
    }
}


// initialize but only if called
function sparkle_init() {

    // to create one div per star / dot
    function create_div(height, width) {
        const div = document.createElement("div");
        div.style.position = "absolute";
        div.style.height = height + "px";
        div.style.width = width + "px";
        div.style.overflow = "hidden";
        return (div);
    }

    // create stars and dots
    for (let i = 0; i < sparkles; i++) {

        // create div for dot
        const tiny_div = create_div(3, 3);
        tiny_div.style.visibility = "hidden";
        tiny_div.style.zIndex = "999";

        // if there's an existing dot, remove it
        if (tiny[i]) {
            document.body.removeChild(tiny[i])
        }

        // append new dot to document
        document.body.appendChild(tiny_div);
        tiny[i] = tiny_div;
        tiny_remaining_ticks[i] = null;

        // create div for star
        const star_div = create_div(5, 5);
        star_div.style.backgroundColor = "transparent";
        star_div.style.visibility = "hidden";
        star_div.style.zIndex = "999";

        // create the actual star using two more divs
        const bar_horiz = create_div(1, 5);
        const bar_vert = create_div(5, 1);
        star_div.appendChild(bar_horiz);
        star_div.appendChild(bar_vert);
        bar_horiz.style.top = "2px";
        bar_horiz.style.left = "0px";
        bar_vert.style.top = "0px";
        bar_vert.style.left = "2px";

        // if there's an existing star, remove it
        if (star[i]) {
            document.body.removeChild(star[i])
        }

        // append new star to document
        document.body.appendChild(star_div);
        star[i] = star_div;
        star_remaining_ticks[i] = null;
    }

    // handle resize
    window.addEventListener('resize', function() {

        // clear everything because I don't want to bother checking which will be out-of-bounds
        for (let i = 0; i < sparkles; i++) {
            // clear all stars
            star_remaining_ticks[i] = null;
            star[i].style.left = "0px";
            star[i].style.top = "0px";
            star[i].style.visibility = "hidden";

            // clear all dots
            tiny_remaining_ticks[i] = null;
            tiny[i].style.top = '0px';
            tiny[i].style.left = '0px';
            tiny[i].style.visibility = "hidden";
        }

        // reset cached height last
        doc_height = document.documentElement.scrollHeight;
        doc_width = document.documentElement.scrollWidth;
    });

    // when the mouse is moved, create stars where the pointer is and where the pointer PROBABLY was
    document.onmousemove = function(e) {
        if (sparkles_enabled && !e.buttons) { // allow more sparkles the faster the mouse moves

            const distance = Math.sqrt(Math.pow(e.movementX, 2) + Math.pow(e.movementY, 2));
            const delta_x = e.movementX * sparkle_distance * 2 / distance;
            const delta_y = e.movementY * sparkle_distance * 2 / distance;
            const probability = distance / sparkle_distance;
            let cumulative_x = 0;

            // where to make the star: where the moise pointer is for now
            let mouse_y = e.pageY;
            let mouse_x = e.pageX;

            // create a star and move back until we reach where the mouse was before
            while (Math.abs(cumulative_x) < Math.abs(e.movementX)) {
                create_star(mouse_x, mouse_y, probability);

                let delta = Math.random();
                mouse_x -= delta_x * delta;
                mouse_y -= delta_y * delta;
                cumulative_x += delta_x * delta;
            }
        }
    };
}

// animation loop
function animate_sparkles(fps = 60) {
    const interval_milliseconds = 1000 / fps;

    let alive = 0;

    for (let i = 0; i < star.length; i++) {
        alive += update_star(i);
    }

    for (let i = 0; i < tiny.length; i++) {
        alive += update_tiny(i);
    }

    if (alive === 0 && !sparkles_enabled) {
        sparkle_destroy();
    }

    setTimeout("animate_sparkles(" + fps + ")", interval_milliseconds);
}

// create a new star at some location
function create_star(x, y, probability = 1.0) {

    // don't create star if it's out of bounds
    if (x + 5 >= doc_width || y + 5 >= doc_height) {
        return;
    }

    // if it's probablistic, give it a chance to do nothing
    if (Math.random() > probability) {
        return;
    }

    // get a color (for the star)
    function get_random_color() {

        let c = [];
        c[0] = 255;
        c[1] = Math.floor(Math.random() * 256);
        c[2] = Math.floor(Math.random() * (256 - c[1] / 2));
        c.sort(function() {
            return (0.5 - Math.random());
        });
        return ("rgb(" + c[0] + ", " + c[1] + ", " + c[2] + ")");
    }

    // which star index do we want to use (either a blank index, or the star closest to dying)
    let min_lifetime = sparkle_lifetime * 2 + 1;
    let min_index = NaN;
    for (let i = 0; i < sparkles; i++) {
        if (!star_remaining_ticks[i]) {
            min_lifetime = null;
            min_index = i;
            break;
        } else if (star_remaining_ticks[i] < min_lifetime) {
            min_lifetime = star_remaining_ticks[i];
            min_index = i;
        }
    }

    // convert existing star to dot before we reuse it
    if (min_lifetime) {
        star_to_tiny(min_index);
    }

    // create a new star
    if (min_index >= 0) {
        star_remaining_ticks[min_index] = sparkle_lifetime * 2;
        star_x[min_index] = x;
        star[min_index].style.left = x + "px";
        star_y[min_index] = y;
        star[min_index].style.top = y + "px";
        star[min_index].style.clip = "rect(0px, 5px, 5px, 0px)";
        star[min_index].childNodes[0].style.backgroundColor =
            star[min_index].childNodes[1].style.backgroundColor = get_random_color();
        star[min_index].style.visibility = "visible";
        return min_index
    }

}

// update one star
function update_star(i) {
    // if star doesn't exist, exit early
    if (star_remaining_ticks[i] === null) {
        return false;
    }

    // tick the lifetime of the star
    star_remaining_ticks[i] -= 1;

    // star is dead?
    if (star_remaining_ticks[i] === 0) {
        star_to_tiny(i);
        return false;
    }

    // star is only half-alive, shrink it
    if (star_remaining_ticks[i] === sparkle_lifetime) {
        star[i].style.clip = "rect(1px, 4px, 4px, 1px)"
    }

    // move the star
    if (star_remaining_ticks[i] > 0) {
        star_y[i] += 1 + 3 * Math.random();
        star_x[i] += (i % 5 - 2) / 5;

        // only move star if it's in-bounds, otherwise, kill it below
        if (star_y[i] + 5 < doc_height && star_x[i] + 5 < doc_width) {
            star[i].style.top = star_y[i] + "px";
            star[i].style.left = star_x[i] + "px";
            return true;
        }
    }

    // kill the star
    star_remaining_ticks[i] = null;
    star[i].style.left = "0px";
    star[i].style.top = "0px";
    star[i].style.visibility = "hidden";
    return false;
}

// convert star to dot
function star_to_tiny(i) {
    // star is dead
    if (star_remaining_ticks[i] === null) {
        return;
    }

    // star is in-bounds, create dot
    if (star_y[i] + 3 < doc_height && star_x[i] + 3 < doc_width) {
        tiny_remaining_ticks[i] = sparkle_lifetime * 2;
        tiny_y[i] = star_y[i];
        tiny[i].style.top = star_y[i] + "px";
        tiny_x[i] = star_x[i];
        tiny[i].style.left = star_x[i] + "px";
        tiny[i].style.width = "2px";
        tiny[i].style.height = "2px";
        tiny[i].style.backgroundColor = star[i].childNodes[0].style.backgroundColor;
        star[i].style.visibility = "hidden";
        tiny[i].style.visibility = "visible";
    }

    // remove star
    star_remaining_ticks[i] = null;
    star[i].style.left = "0px";
    star[i].style.top = "0px";
    star[i].style.visibility = "hidden";
}

// update one dot
function update_tiny(i) {
    // dot is dead
    if (tiny_remaining_ticks[i] === null) {
        return false;
    }

    // tick dot lifetime
    tiny_remaining_ticks[i] -= 1;

    // dot is half-dead, shrink it
    if (tiny_remaining_ticks[i] === sparkle_lifetime) {
        tiny[i].style.width = "1px";
        tiny[i].style.height = "1px";
    }

    // move the dot
    if (tiny_remaining_ticks[i] > 0) {
        tiny_y[i] += 1 + 2 * Math.random();
        tiny_x[i] += (i % 4 - 2) / 4;

        // only allow move if dot is still in-bounds, else kill the dot (below)
        if (tiny_y[i] + 3 < doc_height && tiny_x[i] + 3 < doc_width) {
            tiny[i].style.top = tiny_y[i] + "px";
            tiny[i].style.left = tiny_x[i] + "px";
            return true
        }
    }

    // dot is dead
    tiny_remaining_ticks[i] = null;
    tiny[i].style.top = '0px';
    tiny[i].style.left = '0px';
    tiny[i].style.visibility = "hidden";
    return false
}
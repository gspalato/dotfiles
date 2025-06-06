// This module provides high level utility functions for color manipulation.

/**
 * Returns a color with the hue of color2 and the saturation, value, and alpha of color1.
 *
 * @param {string} color1 - The base color (any Qt.color-compatible string).
 * @param {string} color2 - The color to take hue from.
 * @returns {Qt.rgba} The resulting color.
 */
function colorWithHueOf(color1, color2) {
    var c1 = Qt.color(color1);
    var c2 = Qt.color(color2);

    // Qt.color hsvHue/hsvSaturation/hsvValue/alpha return 0-1
    var hue = c2.hsvHue;
    var sat = c1.hsvSaturation;
    var val = c1.hsvValue;
    var alpha = c1.a;

    return Qt.hsva(hue, sat, val, alpha);
}

/**
 * Returns a color with the saturation of color2 and the hue/value/alpha of color1.
 *
 * @param {string} color1 - The base color (any Qt.color-compatible string).
 * @param {string} color2 - The color to take saturation from.
 * @returns {Qt.rgba} The resulting color.
 */
function colorWithSaturationOf(color1, color2) {
    var c1 = Qt.color(color1);
    var c2 = Qt.color(color2);

    var hue = c1.hsvHue;
    var sat = c2.hsvSaturation;
    var val = c1.hsvValue;
    var alpha = c1.a;

    return Qt.hsva(hue, sat, val, alpha);
}

/**
 * Adapts color1 to the accent (hue and saturation) of color2 using HSL, keeping lightness and alpha from color1.
 *
 * @param {string} color1 - The base color (any Qt.color-compatible string).
 * @param {string} color2 - The accent color.
 * @returns {Qt.rgba} The resulting color.
 */
function adaptToAccent(color1, color2) {
    var c1 = Qt.color(color1);
    var c2 = Qt.color(color2);

    var hue = c2.hslHue;
    var sat = c2.hslSaturation;
    var light = c1.hslLightness;
    var alpha = c1.a;

    return Qt.hsla(hue, sat, light, alpha);
}

/**
 * Mixes two colors by a given percentage.
 *
 * @param {string} color1 - The first color (any Qt.color-compatible string).
 * @param {string} color2 - The second color.
 * @param {number} percentage - The mix ratio (0-1). 1 = all color1, 0 = all color2.
 * @returns {Qt.rgba} The resulting mixed color.
 */
function mix(color1, color2, percentage) {
    var c1 = Qt.color(color1);
    var c2 = Qt.color(color2);
    return Qt.rgba(percentage * c1.r + (1 - percentage) * c2.r, percentage * c1.g + (1 - percentage) * c2.g, percentage * c1.b + (1 - percentage) * c2.b, percentage * c1.a + (1 - percentage) * c2.a);
}

/**
 * Transparentizes a color by a given percentage.
 *
 * @param {string} color - The color (any Qt.color-compatible string).
 * @param {number} percentage - The amount to transparentize (0-1).
 * @returns {Qt.rgba} The resulting color.
 */
function transparentize(color, percentage = 1) {
    var c = Qt.color(color);
    return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
}

/**
 * Sets the alpha channel of a color to a specific value.
 *
 * @param {string} color - The color (any Qt.color-compatible string).
 * @param {number} percentage - The alpha value (0-1).
 * @returns {Qt.rgba} The resulting color.
 */
function alpha(color, alpha) {
    color = Qt.color(color);
    return Qt.rgba(color.r, color.g, color.b, alpha);
}

/**
 * Interpolates between two colors in the LCH color space.
 * Similar to the `mix` function, but uses LCH color space for better perceptual uniformity.
 *
 * @param {Qt.rgba} rgb1 - The first color.
 * @param {Qt.rgba} rgb2 - The second color.
 * @param {number} percentage - The interpolation ratio (0-1).
 * @returns {Qt.rgba} The resulting color.
 */
function interpolateColorsInLCH(rgb1, rgb2, t) {
    const xyz1 = rgbToXyz(rgb1.r, rgb1.g, rgb1.b);
    const lab1 = xyzToLab(xyz1.x, xyz1.y, xyz1.z);
    const lch1 = labToLch(lab1.l, lab1.a, lab1.b);

    const xyz2 = rgbToXyz(rgb2.r, rgb2.g, rgb2.b);
    const lab2 = xyzToLab(xyz2.x, xyz2.y, xyz2.z);
    const lch2 = labToLch(lab2.l, lab2.a, lab2.b);

    // Interpolate L, C, H
    const l = (1 - t) * lch1.l + t * lch2.l;
    const c = (1 - t) * lch1.c + t * lch2.c;

    // Shortest hue interpolation
    let dh = lch2.h - lch1.h;
    if (Math.abs(dh) > 180) {
        dh -= 360 * Math.sign(dh);
    }
    const h = (lch1.h + t * dh + 360) % 360;

    const lab = lchToLab(l, c, h);
    const xyz = labToXyz(lab.l, lab.a, lab.b);
    const rgb = xyzToRgb(xyz.x, xyz.y, xyz.z);
    return Qt.rgba(rgb.r, rgb.g, rgb.b, rgb1.a * (1 - t) + rgb2.a * t);
}


/**
 * Converts a color in RGB color space to XYZ color space.
 *
 * @param {number} r - The red component of the color (0-1).
 * @param {number} g - The green component of the color (0-1).
 * @param {number} b - The blue component of the color (0-1).
 * @returns {Object} The color in XYZ color space, with the following properties:
 *  - x (number): The x component of the color (0-95.047).
 *  - y (number): The y component of the color (0-100.000).
 *  - z (number): The z component of the color (0-108.883).
 */
function rgbToXyz(r, g, b) {
    if (r > 0.04045) {
        r = Math.pow(((r + 0.055) / 1.055), 2.4)
    } else {
        r = r / 12.92
    }

    if (g > 0.04045) {
        g = Math.pow(((g + 0.055) / 1.055), 2.4)
    } else {
        g = g / 12.92
    }

    if (b > 0.04045) {
        b = Math.pow(((b + 0.055) / 1.055), 2.4)
    } else {
        b = b / 12.92
    }

    r *= 100
    g *= 100
    b *= 100

    // Observer = 2°, Illuminant = D65
    const x = r * 0.4124 + g * 0.3576 + b * 0.1805
    const y = r * 0.2126 + g * 0.7152 + b * 0.0722
    const z = r * 0.0193 + g * 0.1192 + b * 0.9505

    return { x, y, z }
}

/**
 * Converts a color in XYZ color space to Lab color space.
 *
 * @param {number} x - The x component of the color (0-95.047).
 * @param {number} y - The y component of the color (0-100.000).
 * @param {number} z - The z component of the color (0-108.883).
 * @returns {Object} The color in Lab color space, with the following properties:
 *  - l (number): The lightness component of the color (0-100).
 *  - a (number): The a component of the color (-128-127).
 *  - b (number): The b component of the color (-128-127).
 */
function xyzToLab(x, y, z) {
    // Observer = 2°, Illuminant = D65
    x = x / 95.047
    y = y / 100.000
    z = z / 108.883

    if (x > 0.008856) {
        x = Math.pow(x, 0.333333333)
    } else {
        x = 7.787 * x + 0.137931034
    }

    if (y > 0.008856) {
        y = Math.pow(y, 0.333333333)
    } else {
        y = 7.787 * y + 0.137931034
    }

    if (z > 0.008856) {
        z = Math.pow(z, 0.333333333)
    } else {
        z = 7.787 * z + 0.137931034
    }

    const l = (116 * y) - 16
    const a = 500 * (x - y)
    const b = 200 * (y - z)

    return { l, a, b }
}

/**
 * Converts a color in Lab color space to LCHab color space.
 *
 * @param {number} l - The lightness component of the color (0-100).
 * @param {number} a - The a component of the color (-128-127).
 * @param {number} b - The b component of the color (-128-127).
 * @returns {Object} The color in LCHab color space, with the following properties:
 *  - l (number): The lightness component of the color (0-100).
 *  - c (number): The chroma component of the color (0-128).
 *  - h (number): The hue component of the color (0-360).
 */
function labToLch(l, a, b) {
    const c = Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2))

    let h = Math.atan2(b, a) //Quadrant by signs
    if (h > 0) {
        h = (h / Math.PI) * 180
    } else {
        h = 360 - (Math.abs(h) / Math.PI) * 180
    }

    return { l, c, h }
}

/**
 * Converts a color in LCHab color space to Lab color space.
 *
 * @param {number} l - The lightness component of the color (0-100).
 * @param {number} c - The chroma component of the color (0-128).
 * @param {number} h - The hue component of the color (0-360).
 * @returns {Object} The color in Lab color space, with the following properties:
 *  - l (number): The lightness component of the color (0-100).
 *  - a (number): The a component of the color (-128-127).
 *  - b (number): The b component of the color (-128-127).
 */
function lchToLab(l, c, h) {
    const a = Math.cos(h * 0.01745329251) * c
    const b = Math.sin(h * 0.01745329251) * c

    return { l, a, b }
}


/**
 * Converts a color in Lab color space to XYZ color space.
 *
 * @param {number} l - The lightness component of the color (0-100).
 * @param {number} a - The a component of the color (-128-127).
 * @param {number} b - The b component of the color (-128-127).
 * @returns {Object} The color in XYZ color space, with the following properties:
 *  - x (number): The x component of the color (0-95.047).
 *  - y (number): The y component of the color (0-100.000).
 *  - z (number): The z component of the color (0-108.883).
 */
function labToXyz(l, a, b) {
    let y = (l + 16) / 116
    let x = a / 500 + y
    let z = y - b / 200

    if (Math.pow(y, 3) > 0.008856) {
        y = Math.pow(y, 3)
    } else {
        y = (y - 0.137931034) / 7.787
    }

    if (Math.pow(x, 3) > 0.008856) {
        x = Math.pow(x, 3)
    } else {
        x = (x - 0.137931034) / 7.787
    }

    if (Math.pow(z, 3) > 0.008856) {
        z = Math.pow(z, 3)
    } else {
        z = (z - 0.137931034) / 7.787
    }

    // Observer = 2°, Illuminant = D65
    x = 95.047 * x
    y = 100.000 * y
    z = 108.883 * z

    return { x, y, z }
}

/**
 * Converts a color in XYZ color space to RGB color space.
 *
 * @param {number} x - The x component of the color (0-95.047).
 * @param {number} y - The y component of the color (0-100.000).
 * @param {number} z - The z component of the color (0-108.883).
 * @returns {Object} The color in RGB color space, with the following properties:
 *  - r (number): The red component of the color (0-1).
 *  - g (number): The green component of the color (0-1).
 *  - b (number): The blue component of the color (0-1).
 */
function xyzToRgb(x, y, z) {
    // Observer = 2°, Illuminant = D65
    x = x / 100 // X from 0 to 95.047
    y = y / 100 // Y from 0 to 100.000
    z = z / 100 // Z from 0 to 108.883

    let r = x * 3.2406 + y * -1.5372 + z * -0.4986
    let g = x * -0.9689 + y * 1.8758 + z * 0.0415
    let b = x * 0.0557 + y * -0.2040 + z * 1.0570

    if (r > 0.0031308) {
        r = 1.055 * (Math.pow(r, 0.41666667)) - 0.055
    } else {
        r = 12.92 * r
    }

    if (g > 0.0031308) {
        g = 1.055 * (Math.pow(g, 0.41666667)) - 0.055
    } else {
        g = 12.92 * g
    }

    if (b > 0.0031308) {
        b = 1.055 * (Math.pow(b, 0.41666667)) - 0.055
    } else {
        b = 12.92 * b
    }

    return { r, g, b }
}
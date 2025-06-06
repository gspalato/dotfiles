/**
 * Resolves the system tray icon path from a given icon request.
 * If the icon request contains a query parameter `?path=`, it extracts the path and constructs a file URL.
 * Otherwise, it returns the icon request as is.
 * 
 * This is useful for handling system tray icons from apps such as Spotify.
 * 
 * @param {string} iconRequest 
 * @param {string} extension 
 * @returns 
 */
function resolveSystemTrayIconPath(iconRequest, extension) {
    const queryIndex = iconRequest.indexOf("?path=");
    if (queryIndex !== -1) {
        const name = iconRequest.substring("image://icon/".length, queryIndex);
        const path = iconRequest.substring(queryIndex + "?path=".length);
        const ext = extension || 'png';
        return "file://" + path + "/" + name + "." + ext;
    } else {
        // No ?path= — return as-is
        return iconRequest;
    }
}
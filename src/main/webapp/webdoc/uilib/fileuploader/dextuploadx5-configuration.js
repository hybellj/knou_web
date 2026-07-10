﻿/* dextuploadx5-configuration Copyright ⓒ DEXTSolution Inc. */

(function (win) {

	let productPath = (new URL(document.currentScript.src)).pathname;
	productPath = productPath.substring(0, productPath.lastIndexOf('/') + 1);

	console.log("productPath="+productPath);

    if (!location.origin) location.origin = location.protocol + "//" + location.host;

    //console.log("location.origin ::: "+location.origin);
    //console.log("window.location.hostname ::: "+window.location.hostname);

    if(location.origin === "https://lms.knou.ac.kr" || location.origin === "http://lms.knou.ac.kr") {

        win.dextuploadx5Configuration = {
            // authkey: Authentication Key string,
			authkey:"PfDZSVtXz9S/dTEy27syms1ro55YXu5aaGoI1iSLHwjNkp4nTruO3pfZ0mRAVKOo3DGI3rR5JAOZP5V/SDTtgBzyP8BdUy9pLWE/WF98bDyCUrWBb30xDwtrrCWaVfcQkWqxv0lXg5BPFX5HGVGjEncYcSH1AQvd5EXLNcMf4eY=",
			version: "4.3.5.0",
            // productPath: DEXTUploadX5 location path (It MUST be a web address started with http or https.)
            productPath: location.origin + productPath
        };
    } else {
        win.dextuploadx5Configuration = {
            // authkey: Authentication Key string,
			authkey:"7KuPVFq4XnHYLFiM9zEkYEFBDGkbLFelqg9Z2HdKudPEZ1Tuix6Mn7ACjkEhGi7WDvy2oZYXOCp1UbZAMZDY/0msxHGAXOiXeSGLFoGsSsPerSRjL4oVbvTS0V12ZIL6fhJeLXK3lBlFScxbBW4kC64d7OiA3d4S+eFN+RG6zT8=",
            version: "4.5.1.0",
            // productPath: DEXTUploadX5 location path (It MUST be a web address started with http or https.)
            productPath: location.origin + productPath
        };
    }

})(window);
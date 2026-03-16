﻿/* dextuploadx5-configuration Copyright ⓒ DEXTSolution Inc. */

(function (win) {

	let productPath = (new URL(document.currentScript.src)).pathname;
	productPath = productPath.substring(0, productPath.lastIndexOf('/') + 1);

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
			authkey:"MsCdtzaN2RZmQxq6KwtpJ6fOfXdfoz+RYTwUzaCzHQ1F3nV3SYyY7YWJXCuwbJ5yNeq2V1v/UwNaaM5h0ugdRBKtOoUvjOhG3DgAHJFUGaTY8eAw4f1wXE3nDSlexfz6/ft796HjvNsqt2rUMAXihXzhKqwhUf4RrkU+xjpwkMw=",
            version: "4.3.5.0",
            // productPath: DEXTUploadX5 location path (It MUST be a web address started with http or https.)
            productPath: location.origin + productPath
        };
    }

})(window);
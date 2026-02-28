﻿/* dextuploadx5-configuration Copyright ⓒ DEXTSolution Inc. */

(function (win) {

    if (!location.origin) location.origin = location.protocol + "//" + location.host;

    //console.log("location.origin ::: "+location.origin);
    //console.log("window.location.hostname ::: "+window.location.hostname);

    if(location.origin === "https://lms.hycu.ac.kr" || location.origin === "http://lms.hycu.ac.kr") {

        win.dextuploadx5Configuration = {
            // authkey: Authentication Key string,
            // lms.hycu.ac.kr
            authkey:"xCy3MqsvLvDH9u/tW7KksqH7Y4xSiSdH00VCtcT7Si3fYCK1ZKsNjhL0uaUOFV/o/U4ZOZWZ2dNVcy1puBNkQVRqPXeJGVi5bVm3KWJyFVRPa/5F9y6CUPzzRCuSnwWvrSN2sbfB7wzVG/bC1ovu4jGNaPWMyUr+7CRzQ94/FRU=",
            version: "3.7.0.0",
            // productPath: DEXTUploadX5 location path (It MUST be a web address started with http or https.)
            productPath: location.origin + "/webdoc/js/dx5/"
        };
    } else {
        win.dextuploadx5Configuration = {
            // authkey: Authentication Key string,
            // devlms.hycu.ac.kr
			//authkey:"32zQObHcaaIwfGP5q6FsaSeB6ViF04lf/MYzQhg+qeApdK6eFyxnblwJDrZociDcPFMYR3BBsSUBIXygmZHY/QwBE62fEOjKteSVW/jkGDCMjEcUszaMLspBI/py9CrdQvP5LPFuzVm1uz+UZBax3seOv8dYcSdSIhnf8w8CnU8=",
			authkey:"PfDZSVtXz9S/dTEy27syms1ro55YXu5aaGoI1iSLHwjNkp4nTruO3pfZ0mRAVKOo3DGI3rR5JAOZP5V/SDTtgBzyP8BdUy9pLWE/WF98bDyCUrWBb30xDwtrrCWaVfcQkWqxv0lXg5BPFX5HGVGjEncYcSH1AQvd5EXLNcMf4eY=",
			// authkey:"sGceTUdmRDurpBCqPS9b8OxS1BE/92hb9DDlqpJ3Gggass72D9IQ2KFkQBLiIul6h0lzb4nYAuySqJln2b/FH04KwqTILcZHB6+ZTt0+yr8/RIrxClw4LrOVgAM/O8WFEC8qWiobKvWlsGXplhR9crMuZcXY0MrbVzkREQkEZVo=",
            version: "4.3.5.0",
            // productPath: DEXTUploadX5 location path (It MUST be a web address started with http or https.)
            productPath: location.origin + "/webdoc/js/dx5/"
        };
    }

})(window);
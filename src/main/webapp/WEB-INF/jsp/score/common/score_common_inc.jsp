<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javascript">
	var scoreCommon = (function() {
	    var chgFloatFormat = function(str, decimalLen) {
	        var idx = str.indexOf('.');
	        if (idx >= 0) {
	            var decimalPart = str.substr(idx + 1);
	            
	            var strArr = str.split(".");
	            str = strArr[0] + "." + strArr[1];
	            
	            if (decimalPart.length > decimalLen) {
	                str = str.substr(0, idx + decimalLen + 1); // 소수점 이하 길이를 decimalLen으로 제한
	            }
	        }
	        return str;
	    }

	    var chgMinusFormat = function(str) {
	        var idx = str.indexOf('-');
	        if (idx == 0) {
	            var tmpStr = str.substr(idx + 1);
	            // 뒤에 마이너스가 또 있는지 확인
	            if (tmpStr.indexOf('-') >= 0) {
	                tmpStr = tmpStr.replace('-', '');
	                str = str.substr(0, idx + 1) + tmpStr;
	            }
	        } else if (idx > 0) {
	            str = str.replace('-', '');
	        } else if (idx < 0) {
	            return str;
	        }

	        return str;
	    }

	    return {
	        // 소수점 이하 길이 제한
	        floatFormat: function(val, isMinus, isFloat, integerLen, decimalLen) {
	            var str = val;
	            // 일단 마이너스, 소수점을 제외한 문자열 모두 제거
	            str = str.replace(/[^-\.0-9]/g, '');
	            // 마이너스
	            if (isMinus) {
	                str = chgMinusFormat(str);
	            } else {
	                str = str.replace('-', '');
	            }

	            // 소수점
	            if (isFloat) {
	                str = chgFloatFormat(str, decimalLen);
	            } else {
	                if (!isMinus) {
	                    str = str.replace('-', '');
	                }

	                str = str.replace('.', '');
	            }

	            // 정수 길이 제한
	            if (integerLen) {
	            	var strArr = str.split(".");
	            	var integerPart = strArr[0];
	            	
	            	if(integerPart.length > 0) {
	            		var integerPartLen = integerPart.length;
	            		var hasMinus = str.indexOf('-') > -1;
	            		
	            		if(hasMinus) {
	            			integerLen = integerLen + 1;
	            		}
	            		
	            		if (integerPart.length > integerLen) {
	            			strArr[0] = integerPart.substr(0, integerLen);
	            			
	            			str = strArr.join(".");
	                    }
	            	}
	            }

	            return str;
	        },
	     	// 소수점 형식 체크
			normalizeFloat: function(inputElement) {
				
				// 입력된 값 가져오기
				var value = inputElement.value;
				
				// 정규식을 사용하여 숫자 형식 검사
				if (/^-?\d+(\.\d+)?$/.test(value)) {
					// 숫자 형식이 맞을 경우, parseFloat() 함수를 사용하여 소수점 포함 숫자로 변환
					var floatValue = parseFloat(value);
			
					// 소수점 이하 1자리까지 반올림
					//floatValue = Math.round(floatValue * 10) / 10;
			
					// 입력된 값 갱신
					inputElement.value = floatValue;
				} else {
					// 숫자 형식이 아닐 경우, 공백으로 설정
					inputElement.value = '';
				}
			}
	    }
	})();

  // HTML 특수 문자를 이스케이프하는 함수
  function escapeHtml(text) {
    var map = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
  }
</script>
//package connectus;
//
//import java.io.IOException;
//import java.util.HashMap;
//import java.util.Map;
//
//import javax.naming.AuthenticationException;
//import javax.security.auth.login.AccountExpiredException;
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import org.springframework.security.authentication.BadCredentialsException;
//import org.springframework.security.authentication.CredentialsExpiredException;
//import org.springframework.security.authentication.DisabledException;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.security.web.authentication.AuthenticationFailureHandler;
//import org.springframework.stereotype.Component;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//
//@Component(value = "authenticationFailureHandler")
//public class DomainFailureHandler implements AuthenticationFailureHandler {
//
//	public void onAuthenticationFailure(HttpServletRequest request,
//                                        HttpServletResponse response,
//                                        AuthenticationException exception) throws IOException, ServletException {
//
//	// 실패로직 핸들링
//
//        exception.printStackTrace();
//
//        writePrintErrorResponse(response, exception);
//    }
//
//    private void writePrintErrorResponse(HttpServletResponse response, AuthenticationException exception) {
//        try {
//            ObjectMapper objectMapper = new ObjectMapper();
//
//            Map<String, Object> responseMap = new HashMap()<>();
//
//            String message = getExceptionMessage(exception);
//
//            responseMap.put("status", 401);
//
//            responseMap.put("message", message);
//
//            response.getOutputStream().println(objectMapper.writeValueAsString(responseMap));
//
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//
//    private String getExceptionMessage(AuthenticationException exception) {
//        if (exception instanceof BadCredentialsException) {
//            return "비밀번호불일치";
//        } else if (exception instanceof UsernameNotFoundException) {
//            return "계정없음";
//        } else if (exception instanceof AccountExpiredException) {
//            return "계정만료";
//        } else if (exception instanceof CredentialsExpiredException) {
//            return "비밀번호만료";
//        } else if (exception instanceof DisabledException) {
//            return "계정비활성화";
//        } else if (exception instanceof LockedException) {
//            return "계정잠김";
//        } else {
//            return "확인된 에러가 없습니다.";
//        }
//    }
//
//}
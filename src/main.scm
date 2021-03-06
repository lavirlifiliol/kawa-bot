(module-compile-options main: #t)
;; scheme does not flush, so using println - using a logger would be better

(import (class net.dv8tion.jda.api JDA)
        (class net.dv8tion.jda.api JDABuilder)
        (class net.dv8tion.jda.api.events ReadyEvent)
        (class net.dv8tion.jda.api.hooks ListenerAdapter)
        (class net.dv8tion.jda.api.events.message MessageReceivedEvent)
        (class net.dv8tion.jda.api.entities ChannelType )
        (class java.lang System)
        (class java.lang Override))

(define-variable ouput)
(define TOKEN (java.lang.System:getenv "BOT_TOKEN"))
(System:out:printf "Hello World, Bot is starting with token %s \n" "[REDACTED]")

((((JDABuilder TOKEN):addEventListeners (MsgListener)):build):awaitReady)
(System:out:println "Bot started \n")
(define-simple-class Util ()
  ((obj->string (obj ::Object) ) allocation: 'static ::string
   (let ((g (open-output-string)))
     (display obj g)
     (get-output-string g))))
(define-simple-class MsgListener (ListenerAdapter)
  ((onReady (event ::ReadyEvent))
   (System:out:println "Bot Ready!\n"))
  ((onMessageReceived (event ::MessageReceivedEvent))
   (let* ((aut (event:getAuthor))
           (msg (event:getMessage))
           (cha (event:getChannel))
           (txt (msg:getContentDisplay)))
      (cond ((string=? "!ping" txt)
             ((cha:sendMessage "Pong!"):queue))
            ((and (> (string-length txt) 5) (string=? "!eval" (string-take txt 5)))
             (begin
               (System:out:printf "Received %s \n" txt)
               ((cha:sendMessage (Util:obj->string (eval (read (open-input-string (string-drop txt 5))) (environment '(scheme base))))):queue)))
            ((and (> (string-length txt) 5) (string=? "!echo" (string-take txt 5)))
             ((cha:sendMessage (string-drop txt 5)):queue))))))

import { Component, OnInit } from '@angular/core';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { FormControl } from '@angular/forms';
import {SocketService} from "../services/socket.service";

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.scss']
})
export class ChatComponent  {

  messages: string[] = [];
  msgControl = new FormControl('');
  usrControl = new FormControl('');
  destroyed$ = new Subject();

  constructor(private chatService: SocketService) { }

  getUsername() : void {
    // @ts-ignore
      this.connect(this.usrControl.value.toString());
  }

  connect(username: string) : void {
      const chatSub$ = this.chatService.connect(username).pipe(
          takeUntil(this.destroyed$),
      );

      chatSub$.subscribe(message => this.messages.push(message));
  }

  sendMessage(): void {
    this.chatService.send(this.msgControl.value);
    this.msgControl.setValue('');
  }

  ngOnDestroy(): void {
    // @ts-ignore
    this.destroyed$.next();
  }

}

import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { UnauthorizedException } from '@nestjs/common';

@Injectable()
export class AuthService {
  constructor(private readonly usersService: UsersService) {}

  async login(email: string, password: string): Promise<{ message: string }> {
    const user = await this.usersService.validateUser(email, password);
    // For now, just return a success message (you can add JWT later)
    return { message: `Welcome back, ${user.name}!` };
  }
}

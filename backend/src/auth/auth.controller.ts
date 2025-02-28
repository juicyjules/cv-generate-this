import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { RegisterUserDto } from './dtos/register-user.dto';
import { LoginUserDto } from './dtos/login-user.dto copy';
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  // Registration endpoint
  @Post('register')
  async register(@Body() registerUserDto: RegisterUserDto) {
      const { name, email, password } = registerUserDto;
      const user = await this.usersService.createUser(name, email, password);
      return { message: 'Registration successful', user };
  }
  
  @Post('login')
  async login(@Body() loginUserDto: LoginUserDto) {
      const { email, password } = loginUserDto;
      return this.authService.login(email, password);
  }
  

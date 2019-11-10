### Assembly Interpreter

This is a very simple intrepreter written in assembly.

#### Notes

I've commented the code quite well, so this isn't really necessary, but it's possibly worth mentioning that this was written for 64-bit OS X (as, since macOS Catalina, 32 bit programs are no longer supported). The main changes are mostly minor, using different registers and syscalls than on 32-bit but otherwise a similar setup.

#### References

[Reference used for 64-bit Registers / Instructions lists](https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start)
[This Gist for finding additional references & iniital setup](https://gist.github.com/FiloSottile/7125822)

> I believe it's because before main is called, the stack is aligned. Then after the call, the act of the call was to push an 8-byte pointer (address of the caller) onto the stack. So at the beginning of main, it's 8 bytes off of the 16-byte alignment. Therefore, instead of 20h you need 28h, bringing the actual total to 28h + 8h (from the call) or 30h. Alignment. :)
[This StackOverflow Question](https://stackoverflow.com/questions/19128291/stack-alignment-in-x64-assembly)

### Assembly Interpreter

This is a very simple intrepreter written in assembly.

#### Notes

Assembly language used: 64-bit NASM, assembled to the Mach-O binary file format.

Program design: Core program flow in `interpreter.asm`, (some) compile-time constants in `constants.asm`, string tooling in `string_tools.asm`, and user input handling in `io.asm`.


#### References

Note: No code in this project was taken from other sources. However, the following references were extremely useful in getting a better understanding of syntax, especially for 64-bit operation specifics.

[Reference used for 64-bit Registers / Instructions lists](https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start)
[This Gist for finding additional references & inital setup](https://gist.github.com/FiloSottile/7125822)
[This Git repository, mostly for understanding the stack](https://gitlab.com/mcmfb/intro_x86-64)
[This StackOverflow Question, also for the stack](https://stackoverflow.com/questions/19128291/stack-alignment-in-x64-assembly)

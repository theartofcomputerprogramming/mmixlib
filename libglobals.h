extern tetra priority;
extern mem_node*mem_root;
extern mem_node*last_mem;
extern octa sclock;
extern octa neg_one;
extern octa cur_loc;
extern int cur_file;
extern int cur_line;
extern tetra cur_freq;
extern octa tmp;
extern tetra obj_time;
extern file_node file_info[256];
extern int buf_size;
extern Char*buffer;
extern FILE*src_file;
extern int shown_file;
extern int shown_line;
extern int gap;
extern bool line_shown;
extern bool showing_source;
extern int profile_gap;
extern bool profile_showing_source;
extern octa implied_loc;
extern bool profile_started;
extern char*special_name[32];
extern octa w,x,y,z,a,b,ma,mb;
extern octa*x_ptr;
extern octa loc;
extern octa inst_ptr;
extern tetra inst;
extern int old_L;
extern int exc;
extern unsigned int tracing_exceptions;
extern int rop;
extern int rzz;
extern int round_mode;
extern bool resuming;
extern bool halted;
extern int breakpoint;
extern bool tracing;
extern bool stack_tracing;
extern bool interacting;
extern bool show_operating_system;
extern bool interact_after_break;
extern bool tripping;
extern bool good;
extern tetra trace_threshold;
extern mmix_opcode op;
extern tetra f;
extern int xx,yy,zz,yz;
extern op_info info[256];
extern int G,L,O;
extern octa g[256];
extern octa*l;
extern int lring_size;
extern int lring_mask;
extern int S;
extern char arg_count[];
extern char*trap_format[];
extern char stdin_buf[256];
extern char*stdin_buf_start;
extern char*stdin_buf_end;
extern octa new_Q;
extern bool showing_stats;
extern bool just_traced;
extern char left_paren[];
extern char right_paren[];
extern char switchable_string[300];
extern char lhs[32];
extern int good_guesses,bad_guesses;
extern char*myself;
extern char**cur_arg;
extern bool interrupt;
extern bool profiling;
extern FILE*fake_stdin;
extern FILE*dump_file;
extern char*usage_help[];
extern char*interactive_help[];
extern jmp_buf mmix_exit;


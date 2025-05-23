
interface TextAreaField {
  label: string;
  placeholder: string;
  error: string | undefined;
  inputStyle: string;
  containerStyle: string;
  onTextChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void;
  minLength?: number;
  maxLength?: number;
}

const TextAreaField = (props: TextAreaField) => {
return (
  <div className={`flex flex-col gap-8 ${props.containerStyle}`}>
      <div className='flex flex-col gap-4'>
       <label className='text-[16px] leading-[28px] text-N400 lg:font-semibold font-medium'>{props.label}</label>
      </div>
      <textarea
       style={{ resize: "none" }}
       className={`py-10 px-16 text-[16px] leading-[28px] font-medium outline-none rounded-md border-[1px]  focus:border-P300
       ${
        props.error ? "border-R200" : "border-N75"
      } 
       ${props.inputStyle}`}
       placeholder={props.placeholder}
       onChange={props.onTextChange}
       maxLength={props.maxLength}
       minLength={props.minLength}
      >
      </textarea>
      <span className="min-h-[13px] text-R300 text-sm">{props.error}</span>
  </div>
)

}

export default TextAreaField
import router from "next/router";
import closePopup from "../../../Assets/closePopup.svg";
import successIcon from "../../../Assets/sucess-icon.svg";
import warningIcon from "../../../Assets/warning-icon.svg";
import Image from "next/image";

interface submitInfoProps {
  removePopup: (state: boolean) => void;
  info: string;
  error?: any | undefined;
}

const SubmitInfo = (props: submitInfoProps) => {
  const handleClosePopUp = () => {
    if (props.info.length > 57) {
      props.removePopup(false);
      router.push("/");
    } else {
      props.removePopup(false);
    }
  };

  const getMessages = (error: any) => {
    const apiError = Object.keys(props.error?.data);
    if(apiError){
      const submitError = props.error?.data[apiError[0]];
      return submitError;
    }
    return 
  }
  return (
    <div className="px-26 py-42 w-[90%] flex flex-col bg-white rounded-lg">
      <div className="flex justify-end w-full">
        <Image
          src={closePopup}
          alt="close-popup"
          className="h-auto w-auto cursor-pointer"
          onClick={() => {
            router.push("/apply");
            props.removePopup(false);
          }}
        />
      </div>
      <div className="w-full flex justify-center items-center">
        <Image
          src={props.info.length > 57 ? successIcon : warningIcon}
          alt="success-icon"
          className="h-[80px] w-[80px]"
        />
      </div>
      <div className="flex flex-col items-center justify-center gap-32">
        {
          props.info && (
            <h4 className="text-N300 text-lg leading-[36px] font-medium text-center py-20 ">
            {props.info}
          </h4>
          )
        }
        {props.info.length === 0 && getMessages(props.error) && (
          <ul>
            {typeof getMessages(props.error) === "object" &&
              getMessages(props.error).map((error: any, index: any) => {
                return (
                  <li key={index}>
                    <p className="text-N300 text-lg leading-[36px] font-medium text-center py-20 ">
                      {error}
                    </p>
                  </li>
                );
              })}
          </ul>
        )}
        <button
          className="py-12 px-40 bg-P300 hover:bg-P200  text-N00 rounded-lg font-semibold"
          onClick={handleClosePopUp}
        >
          Close
        </button>
      </div>
    </div>
  );
};

export default SubmitInfo;

#ifndef QBARLIB_H
#define QBARLIB_H

#include "QBarStruct.h"

#define EXPORTED __attribute__((visibility("default")))

class QBarDecode;
class QBarEncode;

namespace tscan {
class ReaderTimeConsuming;
class QBarTimeConsuming;

namespace debug{
class DebugInfo;
}  // namespace debug
}  // namespace tscan

#ifdef _WIN32
#define __attribute__()
#define __attribute__(x)
#endif

#ifdef _HAS_STD_BYTE
#undef _HAS_STD_BYTE
#endif
#define _HAS_STD_BYTE 0

class QBar
{
public:
    //  ----------feature 20190712 new API----------
    /// 获取结果.
    /// @param results 存放结果.
    /// @return 如果ret=0,results不可用;ret>0,results可用.
    EXPORTED int GetResults(std::vector<QBAR_INFO>& results);
    
    /// 识别一维码、二维码.
    /// @param imageData：传入的灰度（当前引擎仅支持灰度图单通道buffer）
    /// @param width 传入图像宽度
    /// @param height 传入图像高度
    /// @return 如果ret=0,函数正常执行;ret<0,函数非正常执行
    EXPORTED int ScanImage712(uint8_t* imageData, int width, int height);
    
    /// eg: config(CONFIG_MAX_QBAR_OUTPUT_NUM,5) 设置最多输出5个码
    EXPORTED void config(int type,float value);
    EXPORTED std::string getDebugString();
    /// 重置追踪等cache,每次重新检测前需调用.
    EXPORTED void reset(bool for_zoom = false);
    /// 设置用户长按位置在imageData图中的归一化坐标,GetResults前调用
    EXPORTED void SetTouchedCoordinate(float normalize_x,float normalize_y);

    EXPORTED std::string GetCallSnapshot();
    
    EXPORTED bool ReleaseXNetThreadLocalMemory();
    
public:
    /// 初始化.
    /// @param mode：初始化QBar库的模式信息
    /// @return 0:函数正常执行,<0：函数非正常执行,-1：未设置QBAR_SEARCH_MODE
	EXPORTED int Init(QBAR_MODE mode);
    /// 设置识别一维码、二维码的参数.
    /// @param readers：传入需要识别的类型向量
    /// @return 0:函数正常执行,<0：函数非正常执行,-1：未执行Init函数即执行本函数, -2：传入参数错误或传入reader为空
	EXPORTED int SetReaders(std::vector<QBAR_READER> readers);
 
    EXPORTED int ScanImage(uint8_t* imageData, int width, int height);
    /// 获取识别结果，在ScanImage执行之后调用.
    /// @param qbarResults：返回结果的向量
    /// @return >=0:函数正常执行且返回值表示识别出的一维码、二维码个数,<0：函数非正常执行,-1：尚未执行Init或ScanImage函数即执行本函数
    __attribute__((deprecated("deprecated for video moded")))
	EXPORTED int GetResults(std::vector<QBAR_RESULT>& qbarResults);
    /// 获取识别结果，在ScanImage执行之后调用.
    /// @param qbarResults：返回结果的向量
    /// @return >=0:函数正常执行且返回值表示识别出的一维码、二维码个数,<0：函数非正常执行,-1：尚未执行Init或ScanImage函数即执行本函数
    __attribute__((deprecated("deprecated for video moded")))
	EXPORTED int GetOneResult(std::string& typeName, std::string& data, std::string& charset, QBAR_REPORT_MSG * pReportMsg = NULL);
	EXPORTED int GetOneResultReport(std::string& typeName, std::string& data, std::string& charset, std::string& binaryMethod, int& qrcodeVersion, int& pyramidLv );
    EXPORTED int GetZoomInfo(QBAR_ZOOM_INFO &zoomInfo);
    __attribute__((deprecated("deprecated for video moded")))
	EXPORTED int GetDetectInfoByFrames(QBAR_CODE_DETECT_INFO &oInfo);
	EXPORTED int SetCenterCoordinate(int screenX, int screenY, int screenW, int screenH);
    EXPORTED void AddWhiteList(const std::string & white_list);
    EXPORTED void AddBlackList(const std::string & black_list);
    EXPORTED void SetBlackListInternal(int internal);
    EXPORTED void ShowWhiteList();
    EXPORTED void ShowBlackList();
    
	EXPORTED int Release();
    /// 获取当前库版本号.
    /// @return 当前版本号
	EXPORTED static std::string GetVersion();
    /// 生成一、二维码.
    /// @param code：返回生成二维码/一维码的点阵图
    /// @param content：需要编码成二维码/一维码的内容
    /// @param config：生成二维码/一维码的参数
    /// @return >0:函数正常执行,<0:函数非正常执行
    EXPORTED static int Encode(QBAR_IMAGE& code, const std::string & content, const QBAR_ENCODE_CONFIG & config);

	EXPORTED int SetDebugInfo(tscan::debug::DebugInfo & debug_info);
	EXPORTED int SetDebugMode(QBAR_DEBUG debugMode);
	EXPORTED int GetCodeDetectInfo(std::vector<QBAR_CODE_DETECT_INFO> &infoList);
    EXPORTED void SetNextOnceBinarizer( int iBinarizerIndex );
    EXPORTED int GetTimeConsuming(tscan::QBarTimeConsuming & qbar_time_consuming, std::vector<tscan::ReaderTimeConsuming> & reader_time_consumings);
    EXPORTED int GetTimeConsumingV2(void * qbar_time_consuming);

	EXPORTED QBar();
	EXPORTED ~QBar();
    
private:
    QBarDecode * qbarDecode_;
};

class QBarGen
{
public:
    EXPORTED QBarGen();
    EXPORTED ~QBarGen();
    
    /// 生成一、二维码.
    /// @param code：返回生成二维码/一维码的点阵图
    /// @param content：需要编码成二维码/一维码的内容
    /// @param config：生成二维码/一维码的参数
    /// @return >0:函数正常执行,<0:函数非正常执行
    EXPORTED static int Encode(QBAR_IMAGE& code, const std::string & content, const QBAR_ENCODE_CONFIG & config);
    
    EXPORTED static int EncodeQRCodeImage(const std::string &content, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static int EncodeRoundQRCodeImage(const std::string &content, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static int EncodePersonalQRCodeImage(const std::string& content, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);

    // ====== QRCODE VISIALIZE ===== //
    
    EXPORTED static void MakeQRCodeImage(const QBAR_IMAGE& code, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static int MakeRoundQRCode(const QBAR_IMAGE& code, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static int MakePersonQRCode(const QBAR_IMAGE& code, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static int MakePersonColorQRCode(const QBAR_IMAGE& code, const QBAR_ENCODE_CONFIG& config, QBarImageInfo& buf);
    EXPORTED static void GetDominantColors(QBarImageInfo& image, std::vector<std::vector<int>>& domi_colors);
};

#endif

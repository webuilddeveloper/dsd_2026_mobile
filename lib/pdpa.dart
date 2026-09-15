import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/style_theme.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TechnicianPDPA extends StatefulWidget {
  const TechnicianPDPA({super.key});

  @override
  State<TechnicianPDPA> createState() => _TechnicianPDPAState();
}

class _TechnicianPDPAState extends State<TechnicianPDPA> {
  bool _isChecked = false;
  bool _isSubmitting = false;
  bool? _pendingConsent;
  final _storage = const FlutterSecureStorage();

  Future<void> _submitConsent() async {
    if (_isSubmitting || !_isChecked) return;
    setState(() {
      _isSubmitting = true;
      _pendingConsent = true;
    });

    try {
      final code = await _storage.read(key: 'profileCode') ?? '';
      final updateBy = await _storage.read(key: 'profileFirstName') ?? '';
      if (!mounted) return;
      if (code.trim().isEmpty) {
        _showSaveError('ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบใหม่');
        return;
      }

      final result = await postapi('${dsd_server}m/Technician/updatepdpa', {
        'code': code,
        'isPdpa': true,
        'updateBy': updateBy,
      });
      if (!mounted) return;

      if (result is Map && result['status'] == 'S') {
        Navigator.pop(context, true);
      } else {
        _showSaveError(
          result is Map
              ? result['message']?.toString() ?? 'ไม่สามารถบันทึกความยินยอมได้'
              : 'ไม่สามารถบันทึกความยินยอมได้',
        );
      }
    } catch (_) {
      if (mounted) {
        _showSaveError('ไม่สามารถบันทึกความยินยอมได้ กรุณาลองใหม่อีกครั้ง');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _pendingConsent = null;
        });
      }
    }
  }

  void _showSaveError(String message) {
    showDialogFail(
      context,
      title: 'เกิดข้อผิดพลาด',
      description: message,
      onConfirm: () => Navigator.pop(context),
    );
  }

  Widget _buttonLabel(String label, bool consent) {
    if (_isSubmitting && _pendingConsent == consent) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Text(
      label,
      style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.w600),
    );
  }

  static const _consentText =
      'ข้าพเจ้าได้อ่านและรับทราบรายละเอียดข้างต้นแล้ว และยินยอมให้กรมพัฒนาฝีมือแรงงานใช้ชื่อและนามสกุลของข้าพเจ้า เพื่อให้บุคคลภายนอกสามารถค้นหาและตรวจสอบสถานะผ่านระบบว่า ข้าพเจ้ามีสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงานหรือไม่ โดยระบบจะแสดงเฉพาะผลการตรวจสอบสถานะ และจะไม่เปิดเผยข้อมูลส่วนบุคคลอื่นที่ไม่จำเป็น';

  static const _policyContent = '''
<h3>ความยินยอมในการเปิดเผยข้อมูล<br>เพื่อการตรวจสอบสถานะช่าง</h3>
<p><strong>สำหรับการให้บริการผ่านแอปพลิเคชัน DSD E-Cert</strong></p>
<p><strong>เอกสารร่างสำหรับใช้ประกอบการตรวจสอบข้อความและนำไปใช้งานในระบบ</strong></p>
<p>กรมพัฒนาฝีมือแรงงานจัดให้มีบริการตรวจสอบสถานะช่างผ่านแอปพลิเคชัน DSD E-Cert เพื่ออำนวยความสะดวกแก่ประชาชน ผู้ว่าจ้าง นายจ้าง สถานประกอบกิจการ หน่วยงานภาครัฐ หน่วยงานภาคเอกชน หรือบุคคลที่มีความประสงค์จะตรวจสอบว่า บุคคลดังกล่าวมีสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงานหรือไม่</p>
<p>เพื่อให้สามารถให้บริการตรวจสอบสถานะดังกล่าวได้ กรมพัฒนาฝีมือแรงงานขอความยินยอมจากท่านในการใช้ชื่อและนามสกุลของท่านเป็นข้อมูลสำหรับการค้นหาและตรวจสอบสถานะผ่านระบบ โดยระบบจะแสดงผลเฉพาะสถานะการรับรองเท่านั้น</p>
<h3>1. วัตถุประสงค์ในการใช้ข้อมูล</h3>
<p>ข้อมูลชื่อและนามสกุลของท่านจะถูกนำมาใช้เพื่อให้บุคคลภายนอกสามารถค้นหาและตรวจสอบสถานะผ่านระบบของกรมพัฒนาฝีมือแรงงานว่า ท่านมีสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงานหรือไม่</p>
<p>เมื่อมีผู้ใช้งานกรอกชื่อและนามสกุลเพื่อทำการตรวจสอบ ระบบจะประมวลผลและแจ้งเฉพาะผลการตรวจสอบสถานะการรับรอง โดยไม่นำข้อมูลดังกล่าวไปใช้เพื่อวัตถุประสงค์อื่นที่ไม่เกี่ยวข้อง เว้นแต่เป็นกรณีที่มีกฎหมายกำหนดหรือได้รับความยินยอมเพิ่มเติมจากท่าน</p>
<h3>2. ข้อมูลที่ใช้ในการตรวจสอบ</h3>
<p>ระบบจะใช้ข้อมูลเฉพาะที่จำเป็นสำหรับการให้บริการ ได้แก่ “ชื่อ” และ “นามสกุล” เพื่อใช้เป็นข้อมูลสำหรับค้นหาและตรวจสอบกับข้อมูลการรับรองของกรมพัฒนาฝีมือแรงงาน</p>
<p>ระบบจะไม่แสดงข้อมูลส่วนบุคคลอื่นที่ไม่จำเป็นต่อการตรวจสอบสถานะ เช่น เลขประจำตัวประชาชน ที่อยู่ หมายเลขโทรศัพท์ อีเมล วันเดือนปีเกิด หรือข้อมูลส่วนบุคคลอื่น</p>
<h3>3. ผลการตรวจสอบที่แสดงต่อบุคคลภายนอก</h3>
<p>เมื่อบุคคลภายนอกค้นหาด้วยชื่อและนามสกุลที่ตรงกับข้อมูลในระบบ ระบบจะแสดงผลเฉพาะสถานะการรับรอง โดยไม่แสดงรายละเอียดประวัติการฝึกอบรม ผลการทดสอบ เลขที่ใบรับรอง หรือข้อมูลส่วนบุคคลอื่น</p>
<p><strong>กรณีพบข้อมูล</strong></p>
<p>พบสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงาน</p>
<p><strong>กรณีไม่พบข้อมูล</strong></p>
<p>ไม่พบสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงาน</p>
<h3>4. การให้ความยินยอม</h3>
<p>การให้ความยินยอมเป็นไปโดยสมัครใจ เมื่อท่านเลือก “ยินยอม” ถือว่าท่านได้รับทราบและยอมรับให้กรมพัฒนาฝีมือแรงงานใช้ชื่อและนามสกุลของท่านสำหรับการค้นหาและตรวจสอบสถานะช่างผ่านแอปพลิเคชัน DSD E-Cert หรือระบบที่กรมพัฒนาฝีมือแรงงานกำหนด</p>
<p>ท่านยินยอมให้ระบบแจ้งผลแก่ผู้ตรวจสอบว่า “พบสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงาน” หรือ “ไม่พบสถานะเป็นช่างที่ผ่านการรับรองจากกรมพัฒนาฝีมือแรงงาน” ตามข้อมูลที่มีอยู่ในระบบ ณ เวลาที่ทำการตรวจสอบ</p>
<h3>5. การถอนความยินยอม</h3>
<p>ท่านสามารถถอนความยินยอมในการเปิดเผยข้อมูลเพื่อการตรวจสอบสถานะช่างได้ตามช่องทางที่กรมพัฒนาฝีมือแรงงานกำหนด เมื่อการถอนความยินยอมมีผล ระบบจะไม่นำชื่อและนามสกุลของท่านมาใช้สำหรับการให้บุคคลภายนอกค้นหาและตรวจสอบสถานะภายใต้บริการที่อาศัยความยินยอมดังกล่าว</p>
<p>ทั้งนี้ การถอนความยินยอมจะไม่กระทบต่อการดำเนินการเกี่ยวกับข้อมูลที่ได้ดำเนินการโดยชอบก่อนการถอนความยินยอม หรือกรณีที่กรมพัฒนาฝีมือแรงงานมีหน้าที่หรือมีฐานทางกฎหมายอื่นในการเก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลดังกล่าว</p>
<h3>6. ข้อความแสดงความยินยอม</h3>
''';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Scaffold(
        backgroundColor: AppColors.backgroundMain,
        appBar: appBar(
          title: 'ความยินยอมในการเปิดเผยข้อมูล',
          rightBtn: false,
          backAction: () {
            if (!_isSubmitting) Navigator.pop(context);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(data: _policyContent),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: CheckboxListTile(
                          value: _isChecked,
                          onChanged:
                              _isSubmitting
                                  ? null
                                  : (value) {
                                    setState(() => _isChecked = value ?? false);
                                  },
                          title: const Text(
                            _consentText,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isSubmitting
                                ? null
                                : () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textDark,
                          side: const BorderSide(color: AppColors.borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _buttonLabel('ไม่ยินยอม', false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _isChecked && !_isSubmitting
                                ? _submitConsent
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _buttonLabel('ยินยอม', true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

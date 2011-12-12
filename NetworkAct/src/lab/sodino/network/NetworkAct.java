package lab.sodino.network;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
/**
 * 1.点击"Network"将输出本机所处的网络环境。 2.点击"WAP"将设定 移动网络接入点为CMWAP。 3.点击"GPRS"将设定
 * 移动网络接入点为CMNET。 注：自定义移动网络接入点的前提是“设置”→“无线和网络”→“移动网络”处已打勾。
 */
public class NetworkAct extends Activity {
	/** 全部的APN */
	private static final Uri ALL_APN_URI = Uri
			.parse("content://telephony/carriers");
	/** 当前default的APN记录。 */
	private static final Uri PREFERRED_APN_URI = Uri
			.parse("content://telephony/carriers/preferapn");
	private TextView textView;
	private Button btnShowNetInfo;
	private Button btnSetCMWAP;
	private Button btnSetGPRS;
	private BtnClickListener btnListener;
	private ContentValues cvWAP;
	private ContentValues cvGPRS;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		textView = (TextView) findViewById(R.id.infoPanel);
		textView.setBackgroundColor(0xffffffff);
		textView.setTextColor(0xff0000ff);
		textView.setTextSize(15.0f);
		textView.setScrollBarStyle(TextView.SCROLLBARS_OUTSIDE_OVERLAY);
		btnListener = new BtnClickListener();
		btnShowNetInfo = (Button) findViewById(R.id.showInfo);
		btnShowNetInfo.setOnClickListener(btnListener);
		btnSetCMWAP = (Button) findViewById(R.id.setCMWAP);
		btnSetCMWAP.setOnClickListener(btnListener);
		btnSetGPRS = (Button) findViewById(R.id.setGPRS);
		btnSetGPRS.setOnClickListener(btnListener);
		initAPNValues();
	}
	private void initAPNValues() {
		cvWAP = new ContentValues();
		cvWAP.put("name", "移动梦网");
		cvWAP.put("apn", "cmwap");
		// 需要设置为默认接入点则为default
		cvWAP.put("type", "default");
		cvWAP.put("proxy", "10.0.0.172");
		cvWAP.put("port", "80");
		cvWAP.put("mmsproxy", "10.0.0.172");
		cvWAP.put("mmsport", "80");
		cvWAP.put("mmsprotocol", "2.0");
		cvWAP.put("mmsc", "http://mmsc.monternet.com");
		cvWAP.put("mcc", "460");
		cvWAP.put("mnc", "02");
		cvWAP.put("numeric", "46002");
		cvGPRS = new ContentValues();
		cvGPRS.put("name", "GPRS");
		cvGPRS.put("apn", "cmnet");
		// 需要设置为默认接入点则为default
		cvGPRS.put("type", "default");
		// cvGPRS.put("proxy", "10.0.0.172");
		// cvGPRS.put("port", "80");
		// cvGPRS.put("mmsproxy", "10.0.0.172");
		// cvGPRS.put("mmsport", "80");
		cvGPRS.put("mmsprotocol", "2.0");
		// cvGPRS.put("mmsc", "http://mmsc.monternet.com");
		cvGPRS.put("mcc", "460");
		cvGPRS.put("mnc", "02");
		cvGPRS.put("numeric", "46002");
	}
	private void showNetworkInfo() {
		getLocalAddress();
		getWifiAddress();
		getNetworkInfo();
		textView.append("/nList Default Access Point Name:/n");
		listAllAPNs(PREFERRED_APN_URI);
		textView.append("/nList all Access Point Name:/n");
		listAllAPNs(ALL_APN_URI);
	}
	private void getLocalAddress() {
		InetAddress iAdd = null;
		try {
			iAdd = InetAddress.getLocalHost();
			String line = "";
			// line = "HostName=" + iAdd.getHostName() + "/n";
			// textView.append(line);
			// line = "CanonicalHostName=" + iAdd.getCanonicalHostName() + "/n";
			// textView.append(line);
			// line = "HostAddress=" + iAdd.getHostAddress() + "/n";
			// textView.append(line);
			// textView.append("/n");
			String hostName = iAdd.getHostName();
			if (hostName != null) {
				InetAddress[] adds = null;
				adds = InetAddress.getAllByName(hostName);
				if (adds != null) {
					for (int i = 0; i < adds.length; i++) {
						iAdd = adds[i];
						line = "HostName=" + iAdd.getHostName() + "/n";
						textView.append(line);
						line = "CanonicalHostName="
								+ iAdd.getCanonicalHostName() + "/n";
						textView.append(line);
						line = "HostAddress=" + iAdd.getHostAddress() + "/n";
						textView.append(line);
						textView.append("/n");
					}
				}
			}
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface
					.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf
						.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					// if (!inetAddress.isLoopbackAddress()) {
					textView.append("HostAddress="
							+ inetAddress.getHostAddress() + "/n");
					// }
				}
			}
		} catch (SocketException ex) {
			Log.e("WifiPreference IpAddress", ex.toString());
		}
	}
	private void getWifiAddress() {
		WifiManager wifi = (WifiManager) getSystemService(Context.WIFI_SERVICE);
		WifiInfo info = wifi.getConnectionInfo();
		textView.append("HiddenSSID=" + info.getHiddenSSID() + "/n");
		textView.append("IpAddress=" + formatIP4(info.getIpAddress()) + "/n");
		textView.append("LinkSpeed=" + info.getLinkSpeed() + "/n");
		textView.append("NetworkId=" + info.getNetworkId() + "/n");
		textView.append("Rssi=" + info.getRssi() + "/n");
		textView.append("SSID=" + info.getSSID() + "/n");
		textView.append("MacAddress=" + info.getMacAddress() + "/n");
	}
	private void getNetworkInfo() {
		// 此处输出可用网络类型
		ConnectivityManager mag = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		textView.append("/nActive:/n");
		NetworkInfo info = mag.getActiveNetworkInfo();
		if (info != null) {
			textView.append("ExtraInfo=" + info.getExtraInfo() + "/n");
			textView.append("SubtypeName=" + info.getSubtypeName() + "/n");
			textView.append("TypeName=" + info.getTypeName() + "/n");
			textView.append("Type=" + info.getType() + "/n");
		}
		textView.append("/nWifi:/n");
		NetworkInfo wifiInfo = mag
				.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
		textView.append("ExtraInfo=" + wifiInfo.getExtraInfo() + "/n");
		textView.append("SubtypeName=" + wifiInfo.getSubtypeName() + "/n");
		textView.append("TypeName=" + wifiInfo.getTypeName() + "/n");
		textView.append("Type=" + wifiInfo.getType() + "/n");
		NetworkInfo mobInfo = mag
				.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		textView.append("/nMobile:/n");
		textView.append("ExtraInfo=" + mobInfo.getExtraInfo() + "/n");
		textView.append("SubtypeName=" + mobInfo.getSubtypeName() + "/n");
		textView.append("TypeName=" + mobInfo.getTypeName() + "/n");
		textView.append("Type=" + mobInfo.getType() + "/n");
	}
	private void listAllAPNs(Uri apnUri) {
		ContentResolver contentResolver = getContentResolver();
		Cursor cursor = contentResolver.query(apnUri, null, null, null, null);
		if (cursor != null) {
			String temp = "Count=" + cursor.getCount() + " ColumnCount="
					+ cursor.getColumnCount() + "/n";
			textView.append(temp);
			String key = "";
			while (cursor.moveToNext()) {
				key = "position";
				int position = cursor.getPosition();
				textView.append("/n" + key + "=" + String.valueOf(position)
						+ "/n");
				key = "_id";
				int id = cursor.getShort(cursor.getColumnIndex(key));
				textView.append(key + "=" + String.valueOf(id) + "/n");
				appendDBColumn(cursor, "name");
				appendDBColumn(cursor, "apn");
				appendDBColumn(cursor, "type");
				appendDBColumn(cursor, "proxy");
				appendDBColumn(cursor, "port");
				appendDBColumn(cursor, "mmsproxy");
				appendDBColumn(cursor, "mmsport");
				appendDBColumn(cursor, "mmsprotocol");
				appendDBColumn(cursor, "mmsc");
				appendDBColumn(cursor, "current");
				appendDBColumn(cursor, "mcc");
				appendDBColumn(cursor, "mnc");
				appendDBColumn(cursor, "numeric");
			}
		}
	}
	private void appendDBColumn(Cursor cursor, String key) {
		try {
			String value = cursor.getString(cursor.getColumnIndex(key));
			textView.append(key + "=" + value + "/n");
		} catch (Exception e) {
			System.out.println("[sodino] " + e);
		}
	}
	private void setNetworkFeature() {
		// 经测试，start和stop都无效。
		ConnectivityManager connectivityMag = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		int stop = connectivityMag.stopUsingNetworkFeature(
				ConnectivityManager.TYPE_WIFI, "*");
		textView.append("stop=" + String.valueOf(stop) + "/n");
		int start = connectivityMag.startUsingNetworkFeature(
				ConnectivityManager.TYPE_MOBILE,
				ConnectivityManager.EXTRA_NETWORK_INFO);
		textView.append("start=" + String.valueOf(start) + "/n");
	}
	private void setDefaultAPN(ContentValues value) {
		int _id = findAPNId(value);
		if (_id == -1) {
			_id = insertAPN(value);
		}
		textView.append(value.get("name") + " _id=" + _id + "/n");
		ContentValues values = new ContentValues();
		values.put("apn_id", _id);
		ContentResolver resolver = getContentResolver();
		int updateRow = resolver.update(PREFERRED_APN_URI, values, null, null);
		textView.append("updateRow=" + updateRow + "/n");
		textView.append("Set " + value.get("name")
				+ " as default netwrok successed!!/n");
	}
	private int findAPNId(ContentValues cv) {
		int id = -1;
		ContentResolver contentResolver = getContentResolver();
		Cursor cursor = contentResolver.query(ALL_APN_URI, null, null, null,
				null);
		if (cursor != null) {
			while (cursor.moveToNext()) {
				if (cursor.getString(cursor.getColumnIndex("name")).equals(
						cv.get("name"))
						&& cursor.getString(cursor.getColumnIndex("apn"))
								.equals(cv.get("apn"))
						&& cursor.getString(cursor.getColumnIndex("numeric"))
								.equals(cv.get("numeric"))) {
					id = cursor.getShort(cursor.getColumnIndex("_id"));
					break;
				}
			}
		}
		return id;
	}
	private int insertAPN(ContentValues value) {
		int apn_Id = -1;
		ContentResolver resolver = getContentResolver();
		Uri newRow = resolver.insert(ALL_APN_URI, value);
		if (newRow != null) {
			Cursor cursor = resolver.query(newRow,null,null,null,null);
			int idIdx = cursor.getColumnIndex("_id");
			cursor.moveToFirst();
			apn_Id = cursor.getShort(idIdx);
			System.out.println("[sodino] Insert New id:" + apn_Id);
		}
		return apn_Id;
	}
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add("finish");
		return true;
	}
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getTitle().equals("finish")) {
			finish();
		}
		return false;
	}
	/** 将10进制整数形式转换成127.0.0.1形式的IP地址 */
	private static String formatIP4(long longIP) {
		StringBuffer sb = new StringBuffer("");
		sb.append(String.valueOf(longIP >>> 24));
		sb.append(".");
		sb.append(String.valueOf((longIP & 0x00FFFFFF) >>> 16));
		sb.append(".");
		sb.append(String.valueOf((longIP & 0x0000FFFF) >>> 8));
		sb.append(".");
		sb.append(String.valueOf(longIP & 0x000000FF));
		return sb.toString();
	}
	private class BtnClickListener implements OnClickListener {
		public void onClick(View v) {
			textView.setText("");
			if (v == btnShowNetInfo) {
				showNetworkInfo();
			} else if (v == btnSetCMWAP) {
				setDefaultAPN(cvWAP);
				btnSetCMWAP.setEnabled(false);
				btnSetGPRS.setEnabled(true);
			} else if (v == btnSetGPRS) {
				setDefaultAPN(cvGPRS);
				btnSetGPRS.setEnabled(false);
				btnSetCMWAP.setEnabled(true);
			}
		}
	}
}
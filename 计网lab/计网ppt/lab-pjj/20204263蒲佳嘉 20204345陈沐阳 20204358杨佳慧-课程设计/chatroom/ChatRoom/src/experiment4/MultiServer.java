package experiment4;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


//�������ı�����
public class MultiServer {
	static ServerSocket server = null;
	static Socket socket = null;
	static List<Socket> list = new ArrayList<Socket>();  // �洢�ͻ���
	static Map<Socket, Integer> mapServer=new HashMap<>();
	public static void main(String[] args) {
		try {
			System.out.println("�ȴ�����");

			// �ڷ������˶Կͻ��˿����ļ�������߳�
			ServerFileThread serverFileThread = new ServerFileThread();
			serverFileThread.start();
			server = new ServerSocket(5500);
			// �ȴ����Ӳ�������Ӧ�߳�
			while (true) {
				socket = server.accept();  // �ȴ�����
				list.add(socket);  // ��ӵ�ǰ�ͻ��˵��б�
				// �ڷ������˶Կͻ��˿�����Ӧ���߳�
				ServerThread s = new ServerThread(socket);
				s.start();
				System.out.println("���ӳɹ�");
			}
		} catch (IOException e1) {
			e1.printStackTrace();  // �����쳣���ӡ���쳣��λ��
		}
	}
}
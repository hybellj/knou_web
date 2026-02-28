package knou.framework.util;

import java.io.*;
import java.security.SecureRandom;

public final class MediUID
    implements Serializable
{

    public MediUID()
    {
        synchronized(lock)
        {
            if(!hostUniqueSet)
            {
                hostUnique = (new SecureRandom()).nextInt();
                hostUniqueSet = true;
            }
            unique = hostUnique;
            if(lastCount == 32767)
            {
                boolean flag = Thread.interrupted();
                boolean flag1 = false;
                while(!flag1) 
                {
                    long l = System.currentTimeMillis();
                    if(l <= lastTime)
                    {
                        try
                        {
                            Thread.currentThread();
                            Thread.sleep(1L);
                        }
                        catch(InterruptedException interruptedexception)
                        {
                            flag = true;
                        }
                    } else
                    {
                        lastTime = l;
                        lastCount = 0;
                        flag1 = true;
                    }
                }
                if(flag)
                    Thread.currentThread().interrupt();
            }
            time = lastTime;
            count = lastCount++;
        }
    }

    public MediUID(short word0)
    {
        unique = 0;
        time = 0L;
        count = word0;
    }

    private MediUID(int i, long l, short word0)
    {
        unique = i;
        time = l;
        count = word0;
    }

    public int hashCode()
    {
        return (int)time + count;
    }

    public boolean equals(Object obj)
    {
        if(obj instanceof MediUID)
        {
            MediUID uid = (MediUID)obj;
            return unique == uid.unique && count == uid.count && time == uid.time;
        } else
        {
            return false;
        }
    }

    public String toString()
    {
        return (new StringBuilder()).append(Integer.toString(unique, 16)).append(":").append(Long.toString(time, 16)).append(":").append(Integer.toString(count, 16)).toString();
    }

    public void write(DataOutput dataoutput)
        throws IOException
    {
        dataoutput.writeInt(unique);
        dataoutput.writeLong(time);
        dataoutput.writeShort(count);
    }

    public static MediUID read(DataInput datainput)
        throws IOException
    {
        int i = datainput.readInt();
        long l = datainput.readLong();
        short word0 = datainput.readShort();
        return new MediUID(i, l, word0);
    }

    private static int hostUnique;
    private static boolean hostUniqueSet = false;
    private static final Object lock = new Object();
    private static long lastTime = System.currentTimeMillis();
    //private static short lastCount = -32768;
    private static short lastCount = 0;
    private static final long serialVersionUID = 1086053664494604050L;
    private final int unique;
    private final long time;
    private final short count;

}